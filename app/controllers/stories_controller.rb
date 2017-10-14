class StoriesController < MyplaceonlineController
  def may_upload
    true
  end
  
  def self.param_names
    [
      :id,
      :story_name,
      :story_time,
      :story,
      story_pictures_attributes: FilesController.multi_param_names
    ]
  end

  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.stories.story_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["stories.story_time"]
    end

    def obj_params
      params.require(:story).permit(StoriesController.param_names)
    end
end
