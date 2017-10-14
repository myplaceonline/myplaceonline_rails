class WebComicsController < MyplaceonlineController
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.web_comics.web_comic_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(web_comics.web_comic_name)"]
    end

    def obj_params
      params.require(:web_comic).permit(
        :web_comic_name,
        website_attributes: WebsitesController.param_names,
        feed_attributes: FeedsController.param_names
      )
    end
end
