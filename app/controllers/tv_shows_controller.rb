class TvShowsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.tv_shows.tv_show_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(tv_shows.tv_show_name)"]
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
