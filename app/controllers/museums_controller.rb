class MuseumsController < MyplaceonlineController
  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  protected
    def sorts
      ["museums.updated_at DESC"]
    end

    def obj_params
      params.require(:museum).permit(
        :museum_id,
        :museum_type,
        :notes,
        location_attributes: LocationsController.param_names,
        website_attributes: WebsitesController.param_names
      )
    end
end
