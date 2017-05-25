class PicnicLocationsController < MyplaceonlineController
  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def obj_params
      params.require(:picnic_location).permit(
        location_attributes: LocationsController.param_names
      )
    end

    def sorts
      [Location.sorts]
    end
    
    def all_joins
      "INNER JOIN locations ON locations.id = picnic_locations.location_id"
    end

    def all_includes
      :location
    end
end
