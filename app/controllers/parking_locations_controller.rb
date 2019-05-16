class ParkingLocationsController < MyplaceonlineController
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
      location_attributes: LocationsController.param_names,
    ]
  end

  protected
    def obj_params
      params.require(:parking_location).permit(ParkingLocationsController.param_names)
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
      "INNER JOIN locations ON locations.id = parking_locations.location_id"
    end

    def all_includes
      :location
    end

    def show_map?
      true
    end
end
