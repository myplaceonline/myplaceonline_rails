class StoriesController < MyplaceonlineController
  def may_upload
    true
  end

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
        :story,
        story_pictures_attributes: FilesController.multi_param_names
      )
    end
end
