class SleepMeasurementsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.sleep_measurements.sleep_start_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["sleep_measurements.sleep_start_time"]
    end

    def obj_params
      params.require(:sleep_measurement).permit(:sleep_start_time, :sleep_end_time)
    end
end
