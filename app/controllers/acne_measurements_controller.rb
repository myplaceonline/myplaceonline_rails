class AcneMeasurementsController < MyplaceonlineController
  def model
    AcneMeasurement
  end

  def display_obj(obj)
    obj.display
  end

  protected
    def insecure
      true
    end

    def sorts
      ["acne_measurements.measurement_datetime DESC"]
    end

    def obj_params
      params.require(:acne_measurement).permit(:measurement_datetime, :new_pimples, :worrying_pimples, :total_pimples, :acne_location)
    end
    
    def new_obj_initialize
      @obj.measurement_datetime = DateTime.now
    end
end
