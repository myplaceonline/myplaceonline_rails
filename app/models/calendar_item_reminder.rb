class CalendarItemReminder < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  DEFAULT_SNOOZE_TEXT = "1, 00:00:00"
  
  # Should match crontab minimum
  MINIMUM_DURATION_SECONDS = 60*5
  
  belongs_to :calendar_item

  has_many :calendar_item_reminder_pendings, :dependent => :destroy
  
  def self.ensure_pending_all_users()
    Rails.logger.info("ensure_pending_all_users start")
    User.all.each do |user|
      begin
        User.current_user = user
        self.ensure_pending(user)
      ensure
        User.current_user = nil
      end
    end
    Rails.logger.info("ensure_pending_all_users end")
  end

  def self.ensure_pending(user)
    
    # Check if we need to create any future repeat events
    CalendarItem
      .includes(:calendar_item_reminders)
      .where("repeat_amount is not null and is_repeat is null and identity_id = ?", user.primary_identity)
      .each do |calendar_item|
        
        # Find the newest repeat item
        latest_repeat = CalendarItem
          .where(
            is_repeat: true,
            model_class: calendar_item.model_class,
            model_id: calendar_item.model_id,
            context_info: calendar_item.context_info,
            persistent: calendar_item.persistent
          )
          .order("calendar_item_time DESC")
          .limit(1)
          .first
          
        if latest_repeat.nil?
          latest_repeat = calendar_item
        end
        
        # Keep creating repeat items until we hit the target
        target = user.time_now + calendar_item.calendar.largest_threshold_seconds
        
        while latest_repeat.calendar_item_time < target
          timesource = latest_repeat.calendar_item_time
          new_time = case calendar_item.repeat_type
          when Myp::REPEAT_TYPE_SECONDS
            timesource + calendar_item.repeat_amount.seconds
          when Myp::REPEAT_TYPE_MINUTES
            timesource + calendar_item.repeat_amount.minutes
          when Myp::REPEAT_TYPE_HOURS
            timesource + calendar_item.repeat_amount.hours
          when Myp::REPEAT_TYPE_DAYS
            timesource + calendar_item.repeat_amount.days
          when Myp::REPEAT_TYPE_WEEKS
            timesource + calendar_item.repeat_amount.weeks
          when Myp::REPEAT_TYPE_MONTHS
            timesource + calendar_item.repeat_amount.months
          when Myp::REPEAT_TYPE_YEARS
            timesource + calendar_item.repeat_amount.years
          when Myp::REPEAT_TYPE_NTH_MONDAY, Myp::REPEAT_TYPE_NTH_TUESDAY, Myp::REPEAT_TYPE_NTH_WEDNESDAY, Myp::REPEAT_TYPE_NTH_THURSDAY, Myp::REPEAT_TYPE_NTH_FRIDAY, Myp::REPEAT_TYPE_NTH_SATURDAY, Myp::REPEAT_TYPE_NTH_SUNDAY
            # Causes infinite loop because it's always in the same month
            #Repeat.new(
            #  start_date: timesource,
            #  period: calendar_item.repeat_amount,
            #  period_type: Myp.repeat_type_to_period_type(calendar_item.repeat_type)
            #).next_instance
            raise "TODO"
          else
            raise "TODO"
          end
          
          repeated_calendar_item = calendar_item.dup
          repeated_calendar_item.calendar_item_time = new_time
          repeated_calendar_item.calendar_id = calendar_item.calendar_id
          repeated_calendar_item.identity_id = calendar_item.identity_id
          repeated_calendar_item.is_repeat = true
          repeated_calendar_item.save!
          
          calendar_item.calendar_item_reminders.each do |calendar_item_reminder|
            new_calendar_item_reminder = calendar_item_reminder.dup
            new_calendar_item_reminder.calendar_item = repeated_calendar_item
            new_calendar_item_reminder.identity_id = repeated_calendar_item.identity_id
            new_calendar_item_reminder.save!
          end
          
          latest_repeat = repeated_calendar_item
        end
    end
    
    CalendarItemReminder
      .includes(:calendar_item_reminder_pendings, :calendar_item)
      .where(identity: user.primary_identity)
      .each do |calendar_item_reminder|

        # Only check reminders that don't already have items pending
        if calendar_item_reminder.calendar_item_reminder_pendings.count == 0
          now = user.time_now
          if !calendar_item_reminder.calendar_item.calendar_item_time.nil?
            if calendar_item_reminder.calendar_item.calendar_item_time - calendar_item_reminder.threshold_in_seconds.seconds <= now &&
                !calendar_item_reminder.is_expired(now)
              CalendarItemReminderPending.new(
                calendar_item_reminder: calendar_item_reminder,
                calendar: calendar_item_reminder.calendar_item.calendar,
                calendar_item: calendar_item_reminder.calendar_item,
                identity: user.primary_identity
              ).save!
            end
          end
          
          if calendar_item_reminder.is_expired(now)
            calendar_item_reminder.calendar_item_reminder_pendings.each do |calendar_item_reminder_pending|
              calendar_item_reminder_pending.destroy!
            end
          end
        end
    end
  end
  
  def threshold_in_seconds
    if threshold_type.nil? || threshold_amount.nil?
      0
    elsif threshold_type == Myp::REPEAT_TYPE_SECONDS
      threshold_amount
    else
      raise "TODO"
    end
  end
  
  def expires_in_seconds
    if expire_amount.nil? || expire_type.nil?
      0
    elsif expire_type == Myp::REPEAT_TYPE_SECONDS
      expire_amount
    else
      raise "TODO"
    end
  end
  
  def is_expired(dt)
    result = false
    if !expire_amount.nil?
      if calendar_item.calendar_item_time + expires_in_seconds.seconds < dt
        result = true
      end
    end
    result
  end
end
