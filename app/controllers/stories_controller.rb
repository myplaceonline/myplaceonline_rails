class StoriesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["stories.story_time DESC"]
    end

    def obj_params
      params.require(:story).permit(
        :story_name,
        :story_time,
        :story
      )
    end
end
