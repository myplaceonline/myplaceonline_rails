class TimingEventsController < MyplaceonlineController
  def path_name
    "timing_timing_event"
  end

  def form_path
    "timing_events/form"
  end

  def nested
    true
  end

  def footer_items_index
    [
      {
        title: I18n.t("myplaceonline.timing_events.timing"),
        link: timing_path(@parent),
        icon: "back"
      }
    ] + super
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.timing_events.timing"),
        link: timing_path(@obj.timing),
        icon: "back"
      }
    ] + super
  end
  
  protected
    def insecure
      true
    end

    def obj_params
      params.require(:timing_event).permit(
        :timing_event_start,
        :timing_event_end,
        :notes
      )
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      Timing
    end
end
