class DateLocationsController < MyplaceonlineController
  protected
    def sorts
      ["date_locations.updated_at DESC"]
    end

    def obj_params
      params.require(:date_location).permit(
        Myp.select_or_create_permit(params[:date_location], :location_attributes, LocationsController.param_names)
      )
    end
end
