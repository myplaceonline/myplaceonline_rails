class AcneMeasurementsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def default_sort_columns
      ["acne_measurements.measurement_datetime"]
    end
    
    def additional_sorts
      [
        [I18n.t("myplaceonline.acne_measurements.measurement_datetime"), default_sort_columns[0]]
      ]
    end

    def default_sort_direction
      "desc"
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
          identity_file_attributes: FilesController.param_names
        ]
      )
    end
end
