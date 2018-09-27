class BloodTestsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:graph]

  def graph
    @concentrations = ApplicationRecord.connection.execute(%{
      SELECT DISTINCT bc.concentration_name, bc.id
      FROM blood_test_results btr
        INNER JOIN blood_concentrations bc
          ON btr.blood_concentration_id = bc.id
      WHERE btr.identity_id = #{User.current_user.current_identity_id}
      ORDER BY bc.concentration_name
    }).map{|x| [x["concentration_name"], x["id"]]}
    
    @concentration = params[:concentration]
    
    if !@concentration.blank?
      concentration_name = nil
      found_concentration = @concentrations.find{|c| c[1] == @concentration.to_i}
      if !found_concentration.nil?
        concentration_name = found_concentration[0]
      end
      state_hash = { first: true }
      @concentration_results = []
      
      self.all.order(:test_time).each do |blood_test|
        
        Rails.logger.debug{"BloodTestsController.graph blood_test: #{blood_test.id}, #{blood_test.display}"}
        
        blood_test_result = blood_test.blood_concentration(@concentration.to_i)
        if !blood_test_result.nil?
          add_graph_data(
            blood_test,
            blood_test_result.blood_concentration.concentration_name,
            blood_test_result.concentration,
            state_hash,
            @concentration_results
          )
        else
          # See if we can compute it
          if !concentration_name.nil?
            if concentration_name == "Total Cholesterol/HDL"
              hdlc_id = find_concentration_id_by_names(@concentrations, ["HDL", "HDL Cholesterol"])
              
              Rails.logger.debug{"BloodTestsController.graph trying to infer Total-C/HDL, HDL-C: #{hdlc_id}"}
              
              if !hdlc_id.nil?
                
                hdlc = blood_test.blood_concentration(hdlc_id)
                if !hdlc.nil?
                  totalc_id = find_concentration_id_by_names(@concentrations, ["Total Cholesterol"])
                  if !totalc_id.nil?
                    totalc = blood_test.blood_concentration(totalc_id)
                    
                    if !totalc.nil?
                      add_graph_data(
                        blood_test,
                        concentration_name,
                        totalc.concentration / hdlc.concentration,
                        state_hash,
                        @concentration_results
                      )
                    else
                      # The alternative to find Total-C is HDL + Non-HDL (or LDL), which isn't great, but it's something
                      nonhdl_id = find_concentration_id_by_names(@concentrations, ["Non-HDL", "Non-HDL Cholesterol"])
                      
                      Rails.logger.debug{"BloodTestsController.graph non-HDL: #{nonhdl_id}"}
                      
                      if !nonhdl_id.nil?
                        nonhdl = blood_test.blood_concentration(nonhdl_id)
                        if !nonhdl.nil?
                          totalc = hdlc.concentration + nonhdl.concentration
                        end
                      else
                        ldl_id = find_concentration_id_by_names(@concentrations, ["LDL", "LDL Cholesterol"])
                        Rails.logger.debug{"BloodTestsController.graph LDL: #{ldl_id}"}
                        if !ldl_id.nil?
                          ldl = blood_test.blood_concentration(ldl_id)
                          if !ldl.nil?
                            totalc = hdlc.concentration + ldl.concentration
                          end
                        end
                      end
                      
                      Rails.logger.debug{"BloodTestsController.graph totalc: #{totalc}"}
                      
                      if !totalc.nil?
                        add_graph_data(
                          blood_test,
                          concentration_name,
                          totalc / hdlc.concentration,
                          state_hash,
                          @concentration_results
                        )
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      # We used to do a more direct query, but things can get much
      # more complicated such as auto-generation of values (e.g. ratios)
#       @concentration_values = ApplicationRecord.connection.execute(%{
#         SELECT bt.test_time, btr.concentration, bc.concentration_name
#         FROM blood_test_results btr
#           INNER JOIN blood_concentrations bc
#             ON btr.blood_concentration_id = bc.id
#           INNER JOIN blood_tests bt
#             ON btr.blood_test_id = bt.id
#         WHERE btr.identity_id = #{User.current_user.current_identity_id}
#           AND bc.id = #{@concentration.to_i}
#         ORDER BY bt.test_time
#       }).each do |x|
#         if first
#           @graphdata = "Time," + x["concentration_name"]
#           first = false
#         end
#         @graphdata += "\n" + Myp.display_time(x["test_time"], User.current_user, :dygraph)
#         @graphdata += "," + x["concentration"]
#       end
    end
  end
  
  def add_graph_data(blood_test, concentration_name, concentration, state_hash, concentration_results)
    if state_hash[:first]
      @graphdata = "Time," + concentration_name
      state_hash[:first] = false
    end
    @graphdata += "\n" + Myp.display_time(blood_test.test_time, User.current_user, :dygraph)
    @graphdata += "," + concentration.to_s
    
    concentration_results.push(
      {
        blood_test: blood_test,
        concentration: concentration,
      }
    )
  end
  
  def find_concentration_id_by_names(concentrations, names)
    names = names.map{|name| name.downcase}
    found_concentration = concentrations.find{|c| names.include?(c[0].downcase)}
    if !found_concentration.nil?
      found_concentration[1]
    else
      nil
    end
  end
  
  def may_upload
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t('myplaceonline.blood_tests.graph'),
        link: blood_tests_graph_path,
        icon: "grid"
      }
    ]
  end
  
  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.blood_tests.test_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["blood_tests.test_time"]
    end

    def obj_params
      params.require(:blood_test).permit(
        :fast_started,
        :test_time,
        :notes,
        :preceding_changes,
        blood_test_files_attributes: FilesController.multi_param_names,
        location_attributes: LocationsController.param_names,
        doctor_attributes: DoctorsController.param_names,
        blood_test_results_attributes: [
          :id,
          :_destroy,
          :concentration,
          :flag,
          blood_concentration_attributes: BloodConcentration.params
        ]
      )
    end
end
