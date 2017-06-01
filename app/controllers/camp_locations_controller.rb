class CampLocationsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:map]

  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.maps.map"),
        link: camp_locations_map_path,
        icon: "navigation"
      }
    ]
  end
  
  def map
    @locations = self.all.map{ |x|
      if x.location.ensure_gps
        MapLocation.new(
          latitude: x.location.latitude,
          longitude: x.location.longitude,
          label: nil, # No label because it takes too much space on the display
          tooltip: x.display,
          popupHtml: ActionController::Base.helpers.link_to(x.display, x.location.map_url, target: "_blank")
        )
      else
        nil
      end
    }.compact
  end
  
  protected
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
        :boondocking,
        :cell_phone_reception,
        :cell_phone_data,
        :chance_high_wind,
        :birds_chirping,
        :near_busy_road,
        :level_ground,
        location_attributes: LocationsController.param_names,
        membership_attributes: MembershipsController.param_names
      )
    end

    def sorts
      [Location.sorts]
    end
    
    def all_joins
      "INNER JOIN locations ON locations.id = camp_locations.location_id"
    end

    def all_includes
      :location
    end
end
