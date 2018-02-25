class CalendarItemReminderPendingsController < MyplaceonlineController
  
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:complete, :snooze, :short]

  def complete
    set_obj
    ApplicationRecord.transaction do
      @obj.calendar_item_reminder.destroy!
    end
    render json: {
      result: true
    }
  end
  
  def snooze
    set_obj
    duration = Myp.process_duration_timespan_short(params["duration"])
    if !duration.nil?
      ApplicationRecord.transaction do
        new_calendar_item = @obj.calendar_item.clone
        new_calendar_item.calendar_item_time = User.current_user.time_now + duration
        new_calendar_item.calendar = @obj.calendar_item.calendar
        new_calendar_item.identity = @obj.calendar_item.identity
        new_calendar_item.save!
        
        CalendarItemReminder.new(
          identity: new_calendar_item.identity,
          calendar_item: new_calendar_item
        ).save!
        
        @obj.calendar_item_reminder.destroy!
      end
    end
    render json: {
      result: true
    }
  end
  
  def short
    # Don't bother authorizing - we'll redirect and do the authorization there. This leaks
    # some object classes and IDs but that shouldn't matter
    obj = CalendarItemReminderPending.where(id: params[:id].to_i).take
    if !obj.nil?
      redirect_to(obj.calendar_item.link)
    else
      redirect_to(root_path)
    end
  end
  
  def path_name
    "calendar_calendar_item_calendar_item_reminder_calendar_item_reminder_pending"
  end

  def form_path
    "calendar_item_reminder_pendings/form"
  end
  
  def show_path(obj)
    send("#{path_name}_path", obj.calendar_item.calendar, obj.calendar_item, obj.calendar_item_reminder, obj)
  end

  def obj_path(obj = @obj)
    send(path_name + "_path", obj.calendar_item.calendar, obj.calendar_item, obj.calendar_item_reminder, obj)
  end
  
  def edit_obj_path(obj = @obj)
    send("edit_" + path_name + "_path", obj.calendar_item.calendar, obj.calendar_item, obj.calendar_item_reminder, obj)
  end

  def nested
    true
  end
    
  def footer_items_index
    [
      {
        title: I18n.t("myplaceonline.calendar_item_reminder_pendings.calendar_item_reminder"),
        link: calendar_calendar_item_calendar_item_reminder_path(@parent.calendar_item.calendar, @parent.calendar_item, @parent),
        icon: "back"
      }
    ] + super
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.calendar_item_reminder_pendings.calendar_item_reminder"),
        link: calendar_calendar_item_calendar_item_reminder_path(@obj.calendar, @obj.calendar_item, @obj.calendar_item_reminder),
        icon: "back"
      }
    ] + super
  end
  
  protected
    def obj_params
      params.require(:calendar_item_reminder_pendings).permit(
        :trash
      )
    end

    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      [Calendar, CalendarItem, CalendarItemReminder]
    end
end
