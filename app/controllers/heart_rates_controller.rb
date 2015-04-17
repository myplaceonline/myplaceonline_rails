class HeartRatesController < MyplaceonlineController
  def model
    HeartRate
  end

  def display_obj(obj)
    obj.display
  end

  protected
    def sorts
      ["heart_rates.measurement_date DESC"]
    end

    def obj_params
      params.require(:heart_rate).permit(:beats, :measurement_date, :measurement_source)
    end
end
