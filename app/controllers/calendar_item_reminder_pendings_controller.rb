class CalendarItemReminderPendingsController < MyplaceonlineController
  
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:complete, :snooze]

  def complete
    set_obj
    ActiveRecord::Base.transaction do
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
      ActiveRecord::Base.transaction do
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
  
  protected
    def sorts
      ["calendar_item_reminder_pendings.created_at"]
    end

    def obj_params
      params.require(:calendar_item_reminder_pendings).permit(
        :trash
      )
    end

    def has_category
      false
    end
end
