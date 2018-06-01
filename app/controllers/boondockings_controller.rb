class BoondockingsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def obj_params
      params.require(:boondocking).permit(
        camp_location_attributes: CampLocationsController.param_names
      )
    end

    def show_map?
      true
    end
    
    def has_location?(item)
      true
    end
    
    def get_map_location(item)
      item.camp_location.location
    end
end
