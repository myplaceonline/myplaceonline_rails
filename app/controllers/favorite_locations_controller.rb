class FavoriteLocationsController < MyplaceonlineController
  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  def self.reject_if_blank(attributes)
    attributes.dup.all?{|key, value|
      if key == "location_attributes"
        LocationsController.reject_if_blank(value)
      else
        value.blank?
      end
    }
  end

  protected
    def sorts
      ["favorite_locations.updated_at DESC"]
    end

    def obj_params
      params.require(:favorite_location).permit(
        location_attributes: LocationsController.param_names
      )
    end
end
