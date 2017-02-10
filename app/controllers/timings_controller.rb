class TimingsController < MyplaceonlineController
  def show_add
    false
  end
  
  def footer_items_show
    [
      {
        title: I18n.t('myplaceonline.timings.add_timing_event'),
        link: new_timing_timing_event_path(@obj),
        icon: "plus"
      },
      {
        title: I18n.t('myplaceonline.timings.timing_events'),
        link: timing_timing_events_path(@obj),
        icon: "bars"
      },
    ] + super
  end
  
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.seconds_to_time_in_general_human_detailed_hms(obj.average_duration)
  end
    
  protected
    def insecure
      true
    end

    def sorts
      ["lower(timings.timing_name) ASC"]
    end

    def obj_params
      params.require(:timing).permit(
        :timing_name,
        :notes,
        timing_events_attributes: [:id, :_destroy, :timing_event_start, :timing_event_end, :notes]
      )
    end
end
