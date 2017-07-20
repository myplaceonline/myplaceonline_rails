class EventStoriesController < MyplaceonlineController
  def path_name
    "event_event_story"
  end

  def form_path
    "event_stories/form"
  end

  def nested
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.event_stories.event"),
        link: event_path(@parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.event_stories.event"),
        link: event_path(@obj.event),
        icon: "back"
      }
    ]
  end
  
  protected
    def insecure
      true
    end

    def sorts
      ["event_stories.updated_at DESC"]
    end

    def obj_params
      params.require(:event_story).permit(
        :id,
        :_destroy,
        story_attributes: StoriesController.param_names
      )
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      Event
    end
end
