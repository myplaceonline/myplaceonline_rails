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

  def shared
    @obj = model.find_by(id: params[:id])
    authorize! :show, @obj

    if !params[:email_token].nil?
      token = EmailToken.where(token: params[:email_token]).first
      if !token.nil?
        @rsvp = EventRsvp.where(event: @obj, email: token.email).first
      end
    end
  end
  
  def share
    set_obj
    
    redirect_to(
      permissions_share_token_path(
        subject_class: @obj.class.name,
        subject_id: @obj.id,
        child_selections: @obj.event_pictures.map{|x| x.id}.join(",")
      )
    )
  end

  def rsvp
    @obj = model.find_by(id: params[:id])
    authorize! :show, @obj
    
    token = EmailToken.where(token: params[:email_token]).first
    if !token.nil?
      
      rsvp = EventRsvp.where(event: @obj, email: token.email).first
      if rsvp.nil?
        rsvp = EventRsvp.new(event: @obj, email: token.email, identity: @obj.identity)
      end
      
      if params[:type] == Event::RSVP_YES.to_s
        flash = "myplaceonline.events.rsvp_success_reminder"
        flash_type = "myplaceonline.events.rsvp_yes"
        rsvp.rsvp_type = Event::RSVP_YES
      elsif params[:type] == Event::RSVP_MAYBE.to_s
        flash = "myplaceonline.events.rsvp_success_reminder"
        flash_type = "myplaceonline.events.rsvp_maybe"
        rsvp.rsvp_type = Event::RSVP_MAYBE
      else
        flash = "myplaceonline.events.rsvp_success"
        flash_type = "myplaceonline.events.rsvp_no"
        rsvp.rsvp_type = Event::RSVP_NO
      end
      
      begin
        Permission.current_target = @obj
        rsvp.save!
      ensure
        Permission.current_target = nil
      end
      
      redirect_to(
        event_shared_path(token: params[:token], email_token: params[:email_token]),
        :flash => { :notice => I18n.t(flash, type: I18n.t(flash_type)) }
      )
    else
      raise CanCan::AccessDenied.new("Not authorized")
    end
  end
  
  def show_share
    false
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
        event_pictures_attributes: FilesController.multi_param_names + [:position],
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
