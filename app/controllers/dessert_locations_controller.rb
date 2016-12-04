class DessertLocationsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:random]

  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.random.restaurant"),
        link: random_activity_path(:filter_restaurants => "1"),
        icon: "search"
      }
    ]
  end
  
  protected
    def insecure
      true
    end

    def obj_params
      params.require(:dessert_location).permit(
        :notes,
        :visited,
        :rating,
        location_attributes: LocationsController.param_names
      )
    end

    def sorts
      [Location.sorts]
    end
    
    def all_joins
      "INNER JOIN locations ON locations.id = dessert_locations.location_id"
    end

    def all_includes
      :location
    end

    def simple_index_filters
      [
        { name: :not_visited, column: :visited, inverted: true }
      ]
    end
end
