class WebComicsController < MyplaceonlineController
  protected
    def sorts
      ["lower(web_comics.web_comic_name) ASC"]
    end

    def obj_params
      params.require(:web_comic).permit(
        :web_comic_name,
        website_attributes: WebsitesController.param_names,
        feed_attributes: FeedsController.param_names
      )
    end
end
