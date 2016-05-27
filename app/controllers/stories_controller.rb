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

  def self.reject_if_blank(attributes)
    attributes.dup.delete_if {|key, value| key.to_s == "story_time" }.all?{|key, value|
      value.blank?
    }
  end

  protected
    def insecure
      true
    end

    def sorts
      ["stories.story_time DESC"]
    end

    def obj_params
      params.require(:story).permit(StoriesController.param_names)
    end
end
