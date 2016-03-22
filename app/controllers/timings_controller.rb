class TimingsController < MyplaceonlineController
  def show_add
    false
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
