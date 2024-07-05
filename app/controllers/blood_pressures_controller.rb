class BloodPressuresController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:graph]

  def top_content
    I18n.t("myplaceonline.blood_pressures.top_content").html_safe
  end
  
  def graph
    @selectedgraph = params[:selectedgraph]
    if !@selectedgraph.blank?
      @graphdata = "Time," + @selectedgraph

      if @selectedgraph == I18n.t('myplaceonline.blood_pressures.systolic_blood_pressure')
        self.all.each do |blood_pressure|
          @graphdata += "\n" + Myp.display_time(blood_pressure.measurement_date, User.current_user, :dygraph)
          @graphdata += "," + blood_pressure.systolic_pressure.to_s
        end
      else
        self.all.each do |blood_pressure|
          @graphdata += "\n" + Myp.display_time(blood_pressure.measurement_date, User.current_user, :dygraph)
          @graphdata += "," + blood_pressure.diastolic_pressure.to_s
        end
      end
    end
  end
  
  def footer_items_index
    super + [
      {
        title: I18n.t('myplaceonline.blood_pressures.graph'),
        link: blood_pressures_graph_path,
        icon: "grid"
      }
    ]
  end
  
  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.blood_pressures.measurement_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["blood_pressures.measurement_date"]
    end

    def obj_params
      params.require(:blood_pressure).permit(:systolic_pressure, :diastolic_pressure, :measurement_date, :measurement_source)
    end
end
