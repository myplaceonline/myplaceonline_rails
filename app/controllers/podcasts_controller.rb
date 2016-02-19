class PodcastsController < MyplaceonlineController
  protected
    def sorts
      ["podcasts.updated_at DESC"]
    end

    def obj_params
      params.require(:podcast).permit(
        feed_attributes: FeedsController.param_names
      )
    end
end
