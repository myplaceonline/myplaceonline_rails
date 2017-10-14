class TemperaturesController < MyplaceonlineController
  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.temperatures.measured"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["temperatures.measured"]
    end

    def obj_params
      params.require(:temperature).permit(
        :measured,
        :measured_temperature,
        :measurement_source,
        :temperature_type
      )
    end
end
