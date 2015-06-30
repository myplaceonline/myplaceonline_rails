class HeartRatesController < MyplaceonlineController
  def model
    HeartRate
  end

  protected
    def insecure
      true
    end

    def sorts
      ["heart_rates.measurement_date DESC"]
    end

    def obj_params
      params.require(:heart_rate).permit(:beats, :measurement_date, :measurement_source)
    end
end
