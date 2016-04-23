class TvShowsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(tv_shows.tv_show_name) ASC"]
    end

    def obj_params
      params.require(:tv_show).permit(
        :tv_show_name,
        :url,
        :is_watched,
        :tv_genre,
        recommender_attributes: ContactsController.param_names
      )
    end
end
