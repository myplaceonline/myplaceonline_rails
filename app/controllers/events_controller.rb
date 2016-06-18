class EventsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_short_year(obj.event_time, User.current_user)
  end

  protected
    def sorts
      ["events.event_time DESC"]
    end
    
    def obj_params
      params.require(:event).permit(
        :event_name,
        :event_time,
        :event_end_time,
        :notes,
        location_attributes: LocationsController.param_names,
        repeat_attributes: Repeat.params,
        event_pictures_attributes: FilesController.multi_param_names,
        event_contacts_attributes: [
          :id,
          :_destroy,
          contact_attributes: ContactsController.param_names
        ]
      )
    end

    def insecure
      true
    end
end
