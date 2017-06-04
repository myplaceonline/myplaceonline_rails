class GasStationsController < MyplaceonlineController
  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  protected
    def sorts
      ["gas_stations.updated_at DESC"]
    end
    
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
end
