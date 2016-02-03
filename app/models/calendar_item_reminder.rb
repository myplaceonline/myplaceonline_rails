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
          case calendar_item.repeat_type
          when Myp::REPEAT_TYPE_YEARS
            repeated_calendar_item = calendar_item.dup
            repeated_calendar_item.calendar_item_time = Date.new(
              latest_repeat.calendar_item_time.year + 1,
              latest_repeat.calendar_item_time.month,
              latest_repeat.calendar_item_time.day
            )
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
          else
            raise "TOOD"
          end
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
