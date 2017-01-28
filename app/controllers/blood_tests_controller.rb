class BloodTestsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:graph]

  def graph
    @concentrations = ApplicationRecord.connection.execute(%{
      SELECT DISTINCT bc.concentration_name, bc.id
      FROM blood_test_results btr
        INNER JOIN blood_concentrations bc
          ON btr.blood_concentration_id = bc.id
      WHERE btr.identity_id = #{User.current_user.primary_identity_id}
      ORDER BY bc.concentration_name
    }).map{|x| [x["concentration_name"], x["id"]]}
    
    @concentration = params[:concentration]
    
    if !@concentration.blank?
      first = true
      @concentration_values = ApplicationRecord.connection.execute(%{
        SELECT bt.test_time, btr.concentration, bc.concentration_name
        FROM blood_test_results btr
          INNER JOIN blood_concentrations bc
            ON btr.blood_concentration_id = bc.id
          INNER JOIN blood_tests bt
            ON btr.blood_test_id = bt.id
        WHERE btr.identity_id = #{User.current_user.primary_identity_id}
          AND bc.id = #{@concentration.to_i}
        ORDER BY bt.test_time
      }).each do |x|
        if first
          @graphdata = "Time," + x["concentration_name"]
          first = false
        end
        @graphdata += "\n" + Myp.display_time(x["test_time"], User.current_user, :dygraph)
        @graphdata += "," + x["concentration"]
      end
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
    def sorts
      ["blood_tests.test_time DESC"]
    end

    def obj_params
      params.require(:blood_test).permit(
        :fast_started,
        :test_time,
        :notes,
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
