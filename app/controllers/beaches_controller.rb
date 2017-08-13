class BeachesController < MyplaceonlineController
  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  protected
    def insecure
      true
    end

    def obj_params
      params.require(:beach).permit(
        :crowded,
        :notes,
        location_attributes: LocationsController.param_names,
      )
    end

    def sorts
      [Location.sorts]
    end
    
    def all_joins
      "INNER JOIN locations ON locations.id = beaches.location_id"
    end

    def all_includes
      :location
    end
end
