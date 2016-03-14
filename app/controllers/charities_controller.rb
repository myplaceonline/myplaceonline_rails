class CharitiesController < MyplaceonlineController
  protected
    def sorts
      ["charities.updated_at DESC"]
    end

    def obj_params
      params.require(:charity).permit(
        :notes,
        :rating,
        location_attributes: LocationsController.param_names
      )
    end
end
