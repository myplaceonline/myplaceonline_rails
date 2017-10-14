class GasStationsController < MyplaceonlineController
  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  protected
    def obj_params
      params.require(:gas_station).permit(
        :gas,
        :diesel,
        :propane_replacement,
        :propane_fillup,
        :rv_dump_station,
        :notes,
        location_attributes: LocationsController.param_names
      )
    end

    def simple_index_filters
      [
        { name: :gas },
        { name: :diesel },
        { name: :propane_replacement },
        { name: :propane_fillup },
        { name: :rv_dump_station },
      ]
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
      "INNER JOIN locations ON locations.id = gas_stations.location_id"
    end

    def all_includes
      :location
    end
end
