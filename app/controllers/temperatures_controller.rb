class TemperaturesController < MyplaceonlineController
  def model
    Temperature
  end

  def display_obj(obj)
    obj.display
  end

  protected
    def sorts
      ["temperatures.measured DESC"]
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
