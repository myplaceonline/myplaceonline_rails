class EventsController < MyplaceonlineController
  protected
    def sorts
      ["lower(events.event_name) ASC"]
    end
    
    def obj_params
      params.require(:event).permit(
        :event_name,
        :event_time,
        :event_end_time,
        :notes,
        Myp.select_or_create_permit(params[:event], :location_attributes, LocationsController.param_names),
        repeat_attributes: Repeat.params
      )
    end

    def insecure
      true
    end
end
