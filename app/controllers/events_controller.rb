class EventsController < MyplaceonlineController
  def may_upload
    true
  end

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
        repeat_attributes: Repeat.params,
        event_pictures_attributes: [
          :id,
          :_destroy,
          identity_file_attributes: [
            :id,
            :file,
            :notes
          ]
        ]
      )
    end

    def insecure
      true
    end
end
