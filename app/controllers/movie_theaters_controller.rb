class MovieTheatersController < MyplaceonlineController
  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  protected
    def sorts
      ["movie_theaters.updated_at DESC"]
    end
    
    def obj_params
      params.require(:movie_theater).permit(
        location_attributes: LocationsController.param_names
      )
    end
end
