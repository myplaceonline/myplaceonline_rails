class DietaryRequirementsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(dietary_requirements.dietary_requirement_name) ASC"]
    end

    def obj_params
      params.require(:dietary_requirement).permit(
        :dietary_requirement_name,
        :notes,
        :dietary_requirement_amount,
        :dietary_requirement_type,
        :dietary_requirement_context,
      )
    end
end
