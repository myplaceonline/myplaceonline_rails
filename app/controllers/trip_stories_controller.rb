class TripStoriesController < MyplaceonlineController
  def path_name
    "trip_trip_story"
  end

  def form_path
    "trip_stories/form"
  end

  protected
    def insecure
      true
    end

    def sorts
      ["trip_stories.updated_at DESC"]
    end

    def obj_params
      params.require(:trip_story).permit(
        :id,
        :_destroy,
        story_attributes: StoriesController.param_names
      )
    end
    
    def has_category
      false
    end
    
    def nested
      true
    end
    
    def additional_items?
      false
    end

    def parent_model
      Trip
    end
end
