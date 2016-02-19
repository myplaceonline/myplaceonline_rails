class MoviesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(movies.name) ASC"]
    end

    def obj_params
      params.require(:movie).permit(
        :name,
        :url,
        :is_watched,
        :genre,
        recommender_attributes: ContactsController.param_names
      )
    end
end
