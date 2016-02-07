class MovieTheatersController < MyplaceonlineController
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
