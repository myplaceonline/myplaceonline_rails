class HeartRatesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.heart_rates.measurement_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["heart_rates.measurement_date"]
    end

    def obj_params
      params.require(:heart_rate).permit(:beats, :measurement_date, :measurement_source)
    end
end
