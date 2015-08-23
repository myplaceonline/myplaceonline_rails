class AcneMeasurementsController < MyplaceonlineController
  def model
    AcneMeasurement
  end
  
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["acne_measurements.measurement_datetime DESC"]
    end

    def obj_params
      params.require(:acne_measurement).permit(
        :measurement_datetime,
        :new_pimples,
        :worrying_pimples,
        :total_pimples,
        :acne_location,
        acne_measurement_pictures_attributes: [
          :id,
          :_destroy,
          identity_file_attributes: [
            :id,
            :file,
            :notes
          ]
        ]
      )
    end
end
