class CampLocationsController < MyplaceonlineController

  def model
    CampLocation
  end

  protected
    def sorts
      ["camp_locations.updated_at DESC"]
    end

    def obj_params
      params.require(:camp_location).permit(
        :notes,
        :rating,
        :vehicle_parking,
        :free,
        :sewage,
        :fresh_water,
        :electricity,
        :internet,
        :trash,
        :shower,
        :bathroom,
        :noise_level,
        :overnight_allowed,
        Myp.select_or_create_permit(params[:camp_location], :location_attributes, LocationsController.param_names)
      )
    end
end
