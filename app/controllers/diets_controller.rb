class DietsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(diets.diet_name) ASC"]
    end

    def obj_params
      params.require(:diet).permit(
        :diet_name,
        :notes,
        dietary_requirements_collection_attributes: DietaryRequirementsCollection.param_names
      )
    end
end
