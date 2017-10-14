class DietaryRequirementsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.dietary_requirements.dietary_requirement_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(dietary_requirements.dietary_requirement_name)"]
    end

    def obj_params
      params.require(:dietary_requirement).permit(
        DietaryRequirement.params
      )
    end
end
