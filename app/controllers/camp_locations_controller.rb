class CampLocationsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:map]

  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end
  
  def self.param_names
    [
      :id,
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
      :nightly_cost,
      :slideout_okay,
      :limited_time_parking,
      :unlimited_time_parking,
      location_attributes: LocationsController.param_names,
      membership_attributes: MembershipsController.param_names
    ]
  end
  
  def simple_index_filters
    [
      { name: :overnight_allowed },
      { name: :slideout_okay },
      { name: :free },
      { name: :internet },
      { name: :boondocking },
      { name: :cell_phone_reception },
      { name: :cell_phone_data },
      { name: :level_ground },
      { name: :limited_time_parking },
      { name: :unlimited_time_parking },
    ]
  end

  protected
    def obj_params
      params.require(:camp_location).permit(CampLocationsController.param_names)
    end

    def default_sort_columns
      [Location.sorts]
    end
    
    def additional_sorts
      [
        [I18n.t("myplaceonline.locations.name"), default_sort_columns[0]]
      ]
    end

    def all_joins
      "INNER JOIN locations ON locations.id = camp_locations.location_id"
    end

    def all_includes
      :location
    end

    def show_map?
      true
    end
end
