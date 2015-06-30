class SleepMeasurementsController < MyplaceonlineController
  def model
    SleepMeasurement
  end

  protected
    def insecure
      true
    end

    def sorts
      ["sleep_measurements.sleep_start_time DESC"]
    end

    def obj_params
      params.require(:sleep_measurement).permit(:sleep_start_time, :sleep_end_time)
    end
end
