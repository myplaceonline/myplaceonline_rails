class DesiredLocationsController < MyplaceonlineController
  protected
    def sorts
      ["desired_locations.updated_at DESC"]
    end

    def obj_params
      params.require(:desired_location).permit(
        location_attributes: LocationsController.param_names
      )
    end
end
