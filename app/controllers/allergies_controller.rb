class AllergiesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.allergies.allergy_description"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["allergies.allergy_description"]
    end

    def obj_params
      params.require(:allergy).permit(
        :allergy_description,
        :started,
        :ended,
        :notes,
        allergy_files_attributes: FilesController.multi_param_names,
      )
    end
end
