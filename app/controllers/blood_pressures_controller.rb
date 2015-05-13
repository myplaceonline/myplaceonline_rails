class BloodPressuresController < MyplaceonlineController
  def model
    BloodPressure
  end

  def display_obj(obj)
    obj.display
  end

  protected
    def insecure
      true
    end

    def sorts
      ["blood_pressures.measurement_date DESC"]
    end

    def obj_params
      params.require(:blood_pressure).permit(:systolic_pressure, :diastolic_pressure, :measurement_date, :measurement_source)
    end
end
