class AcneMeasurementsController < MyplaceonlineController
  def model
    AcneMeasurement
  end

  def display_obj(obj)
    obj.display
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
    
    def new_obj_initialize
      @obj.measurement_datetime = DateTime.now
    end

    def presave
      @obj.acne_measurement_pictures.each do |pic|
        if pic.identity_file.folder.nil?
          pic.identity_file.folder = IdentityFileFolder.find_or_create([I18n.t("myplaceonline.category.acne_measurements"), @obj.display])
        end
      end
    end
end
