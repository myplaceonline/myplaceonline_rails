class DesiredLocationsController < MyplaceonlineController
  protected
    def sorts
      ["desired_locations.updated_at DESC"]
    end

    def obj_params
      params.require(:desired_location).permit(
        Myp.select_or_create_permit(params[:desired_location], :location_attributes, LocationsController.param_names)
      )
    end
end
