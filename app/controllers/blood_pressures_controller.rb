class BloodPressuresController < MyplaceonlineController
  def top_content
    I18n.t("myplaceonline.blood_pressures.top_content").html_safe
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
