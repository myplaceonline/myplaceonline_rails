class CalendarItemReminder < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  DEFAULT_SNOOZE_TEXT = "1, 00:00:00"
  
  # Should match crontab minimum
  MINIMUM_DURATION_SECONDS = 60*5
  
  belongs_to :calendar_item

  has_many :calendar_item_reminder_pendings, :dependent => :destroy
  
  def display
    Myp.display_datetime(calendar_item.calendar_item_time, User.current_user)
  end
  
  def self.ensure_pending_all_users()
    Rails.logger.info("ensure_pending_all_users start")
    got_lock = false
    begin
      got_lock = Myp.database_advisory_lock(1)
      if got_lock
        User.all.each do |user|
          begin
            User.current_user = user
            self.ensure_pending(user)
          ensure
            User.current_user = nil
          end
        end
      else
        Rails.logger.info("ensure_pending_all_users failed lock")
      end
    ensure
      if got_lock
        Myp.database_advisory_unlock(1)
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
        
        Rails.logger.debug{"ensure_pending calendar_item=#{calendar_item.inspect}"}

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
          Rails.logger.debug{"no repeat items found"}
          latest_repeat = calendar_item
        end
        
        # Keep creating repeat items until we hit the target
        target = Time.now + calendar_item.calendar.largest_threshold_seconds
        
        Rails.logger.debug{"target=#{target}"}

        while latest_repeat.calendar_item_time < target
          timesource = latest_repeat.calendar_item_time
          
          Rails.logger.debug{"loop processing #{timesource.inspect}"}
          
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
            when Myp::REPEAT_TYPE_6MONTHS
              timesource + (calendar_item.repeat_amount * 6).months
            when Myp::REPEAT_TYPE_YEARS
              timesource + calendar_item.repeat_amount.years
            when Myp::REPEAT_TYPE_NTH_MONDAY, Myp::REPEAT_TYPE_NTH_TUESDAY, Myp::REPEAT_TYPE_NTH_WEDNESDAY, Myp::REPEAT_TYPE_NTH_THURSDAY, Myp::REPEAT_TYPE_NTH_FRIDAY, Myp::REPEAT_TYPE_NTH_SATURDAY, Myp::REPEAT_TYPE_NTH_SUNDAY
              wday = Myp.repeat_type_nth_to_wday(calendar_item.repeat_type)
              x = Myp.find_nth_weekday(timesource.year, timesource.month, wday, calendar_item.repeat_amount)
              if x.nil? || x <= timesource
                if timesource.month == 12
                  x = Myp.find_nth_weekday(timesource.year + 1, 1, wday, calendar_item.repeat_amount)
                else
                  x = Myp.find_nth_weekday(timesource.year, timesource.month + 1, wday, calendar_item.repeat_amount)
                end
              end
              if !x.nil? && x < target
                Rails.logger.debug{"repeat nth returning #{x.inspect}"}
                x
              else
                Rails.logger.debug{"repeat nth returning nil"}
                nil
              end
            else
              raise "TODO"
            end
          
          if !new_time.nil?
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
            
            Rails.logger.debug{"latest_repeat=#{latest_repeat.inspect}"}
          else
            break
          end
        end

        Rails.logger.debug{"completed calendar_item"}
    end
    
    Rails.logger.debug{"checking calendar item reminder pendings"}
    
    now = Time.now
    
    CalendarItemReminder
      .includes(:calendar_item_reminder_pendings, :calendar_item)
      .where(identity: user.primary_identity)
      .each do |calendar_item_reminder|

        Rails.logger.debug{"checking reminder=#{calendar_item_reminder.inspect}. Item: #{calendar_item_reminder.calendar_item.display}"}
        
        if calendar_item_reminder.calendar_item_reminder_pendings.count == 0
          if !calendar_item_reminder.calendar_item.calendar_item_time.nil?

            Rails.logger.debug{"calendar_item_time = #{calendar_item_reminder.calendar_item.calendar_item_time}"}
        
            if calendar_item_reminder.calendar_item.calendar_item_time - calendar_item_reminder.threshold_in_seconds.seconds <= now &&
                !calendar_item_reminder.is_expired(now)
              
              Rails.logger.debug{"meets threshold of #{calendar_item_reminder.threshold_in_seconds.seconds}"}
        
              # If there's a max_pending (often 1), then delete any pending
              # items beyond that amount
              if !calendar_item_reminder.max_pending.nil?
                CalendarItemReminderPending.find_by_sql(
                  %{
                    SELECT calendar_item_reminder_pendings.*
                    FROM calendar_item_reminder_pendings
                      INNER JOIN calendar_items
                        ON calendar_item_reminder_pendings.calendar_item_id = calendar_items.id
                    WHERE calendar_item_reminder_pendings.calendar_id = #{calendar_item_reminder.calendar_item.calendar.id}
                      AND calendar_item_reminder_pendings.identity_id = #{user.primary_identity.id}
                      AND calendar_items.model_class #{Myp.sanitize_with_null(calendar_item_reminder.calendar_item.model_class)}
                      AND calendar_items.model_id #{Myp.sanitize_with_null(calendar_item_reminder.calendar_item.model_id)}
                    ORDER BY calendar_items.calendar_item_time ASC
                  }
                ).first(calendar_item_reminder.max_pending).each{
                  |x|
                  Rails.logger.debug{"destroying pending item #{x.inspect}"}
                  x.destroy!
                }
              end
              
              new_pending = CalendarItemReminderPending.new(
                calendar_item_reminder: calendar_item_reminder,
                calendar: calendar_item_reminder.calendar_item.calendar,
                calendar_item: calendar_item_reminder.calendar_item,
                identity: user.primary_identity
              )
              
              new_pending.save!

              Rails.logger.debug{"created new pending item #{new_pending.inspect}"}
            end
          end
        end
        
        is_expired = calendar_item_reminder.is_expired(now)

        Rails.logger.debug{"is_expired = #{is_expired}"}

        if is_expired
          Rails.logger.debug{"reminder expired, deleting #{calendar_item_reminder.calendar_item_reminder_pendings.count} pendings"}
          
          calendar_item_reminder.calendar_item_reminder_pendings.each do |calendar_item_reminder_pending|
            calendar_item_reminder_pending.destroy!
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
      if !calendar_item.calendar_item_time.nil? && calendar_item.calendar_item_time + expires_in_seconds.seconds < dt
        result = true
      end
    end
    result
  end
end
