class FavoriteLocationsController < MyplaceonlineController
  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  protected
    def default_sort_columns
      [Location.sorts]
    end
    
    def additional_sorts
      [
        [I18n.t("myplaceonline.locations.name"), default_sort_columns[0]]
      ]
    end

    def all_joins
      "INNER JOIN locations ON locations.id = favorite_locations.location_id"
    end

    def all_includes
      :location
    end

    def obj_params
      params.require(:favorite_location).permit(
        :rating,
        location_attributes: LocationsController.param_names
      )
    end

    def show_map?
      true
    end
end
