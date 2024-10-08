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

  def simple_index_filters
    [
      { name: :shadedareas },
      { name: :treeshade },
      { name: :coal_disposal },
    ]
  end

  protected
    def insecure
      true
    end

    def obj_params
      params.require(:picnic_location).permit(
        :rating,
        :shadedareas,
        :treeshade,
        :coal_disposal,
        location_attributes: LocationsController.param_names
      )
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
      "INNER JOIN locations ON locations.id = picnic_locations.location_id"
    end

    def all_includes
      :location
    end

    def show_map?
      true
    end
end
