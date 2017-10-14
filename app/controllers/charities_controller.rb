class CharitiesController < MyplaceonlineController
  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  protected
    def obj_params
      params.require(:charity).permit(
        :notes,
        :rating,
        location_attributes: LocationsController.param_names
      )
    end
end
