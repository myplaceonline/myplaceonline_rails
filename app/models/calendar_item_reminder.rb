class CalendarItemReminder < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  DEFAULT_SNOOZE_TEXT = "1, 00:00:00"
  
  # Should match crontab minimum
  MINIMUM_DURATION_SECONDS = 60*5
  
  belongs_to :calendar_item

  child_properties(name: :calendar_item_reminder_pendings, sort: "created_at ASC")
  
  def display
    Myp.display_datetime(calendar_item.calendar_item_time, User.current_user)
  end
  
  def self.ensure_pending_all_users()
    Rails.logger.info("CalendarItemReminder.ensure_pending_all_users start")

    # Error "current transaction is aborted, commands ignored until end of transaction block" is caused by a previous transaction error
    executed = Myp.try_with_database_advisory_lock(Myp::DB_LOCK_CALENDAR_ITEM_REMINDERS_ALL, 1) do
      User.all.each do |user|
        MyplaceonlineExecutionContext.do_semifull_context(user) do
          self.ensure_pending(user)
        end
      end
    end
    
    if !executed
      Rails.logger.info("CalendarItemReminder.ensure_pending_all_users could not lock (#{Myp::DB_LOCK_CALENDAR_ITEM_REMINDERS_ALL}, 1)")
    end

    Rails.logger.info("CalendarItemReminder.ensure_pending_all_users end")
  end
  
  def self.ensure_pending_process(user, identity)
    Rails.logger.debug("CalendarItemReminder.ensure_pending_process start #{user.id}")

    # Check if we need to create any future repeat events
    CalendarItem
      .includes(:calendar_item_reminders)
      .where("repeat_amount is not null and is_repeat is null and identity_id = ?", identity)
      .each do |calendar_item|
        
        Rails.logger.debug{"CalendarItemReminder.ensure_pending_process calendar_item=#{calendar_item.inspect}"}
        
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
          Rails.logger.debug{"CalendarItemReminder.ensure_pending_process no repeat items found"}
          latest_repeat = calendar_item
        end
        
        # Keep creating repeat items until we hit the target
        target = Time.now + calendar_item.calendar.largest_threshold_seconds
        
        Rails.logger.debug{"CalendarItemReminder.ensure_pending_process target=#{target}"}

        while latest_repeat.calendar_item_time < target
          timesource = latest_repeat.calendar_item_time
          
          Rails.logger.debug{"CalendarItemReminder.ensure_pending_process loop processing #{timesource.inspect}"}
          
          new_time = case calendar_item.repeat_type
            when Myp::TIME_DURATION_SECONDS
              timesource + calendar_item.repeat_amount.seconds
            when Myp::TIME_DURATION_MINUTES
              timesource + calendar_item.repeat_amount.minutes
            when Myp::TIME_DURATION_HOURS
              timesource + calendar_item.repeat_amount.hours
            when Myp::TIME_DURATION_DAYS
              timesource + calendar_item.repeat_amount.days
            when Myp::TIME_DURATION_WEEKS
              timesource + calendar_item.repeat_amount.weeks
            when Myp::TIME_DURATION_MONTHS
              timesource + calendar_item.repeat_amount.months
            when Myp::TIME_DURATION_YEARS
              timesource + calendar_item.repeat_amount.years
            when Myp::TIME_DURATION_6MONTHS
              timesource + (calendar_item.repeat_amount * 6).months
            when Myp::TIME_DURATION_YEARS
              timesource + calendar_item.repeat_amount.years
            when Myp::TIME_DURATION_NTH_MONDAY, Myp::TIME_DURATION_NTH_TUESDAY, Myp::TIME_DURATION_NTH_WEDNESDAY, Myp::TIME_DURATION_NTH_THURSDAY, Myp::TIME_DURATION_NTH_FRIDAY, Myp::TIME_DURATION_NTH_SATURDAY, Myp::TIME_DURATION_NTH_SUNDAY
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
                Rails.logger.debug{"CalendarItemReminder.ensure_pending_process repeat nth returning #{x.inspect}"}
                x
              else
                Rails.logger.debug{"CalendarItemReminder.ensure_pending_process repeat nth returning nil"}
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
            
            Rails.logger.debug{"CalendarItemReminder.ensure_pending_process latest_repeat=#{latest_repeat.inspect}"}
          else
            break
          end
        end

        Rails.logger.debug{"CalendarItemReminder.ensure_pending_process completed calendar_item"}
    end
    
    # All dates in the DB are UTC
    now = Time.now.utc

    Rails.logger.debug{"CalendarItemReminder.ensure_pending_process checking calendar item reminder pendings, now: #{now}"}
    
    # Select the original calendar item (is_repeat = NULL/false) and all of its repeats:
    #
    # select i.identity_id, i.id as item_id, i.calendar_id, i.calendar_item_time, i.is_repeat, r.id as reminder_id, r.threshold_amount, r.threshold_type, r.repeat_amount, r.repeat_type, r.expire_amount, r.expire_type, r.max_pending, p.id as pending_id from calendar_items i left outer join calendar_item_reminders r on i.id = r.calendar_item_id left outer join calendar_item_reminder_pendings p on p.calendar_item_reminder_id = r.id where i.model_class = 'ApartmentTrashPickup' and i.model_id = 1 order by i.calendar_item_time;
    
    CalendarItemReminder
      .includes(:calendar_item_reminder_pendings, :calendar_item)
      .where(identity: identity)
      .each do |calendar_item_reminder|
        
        # If for some reason the model object doesn't exist, then just destroy this reminder
        if calendar_item_reminder.calendar_item.model_id_valid?
          Rails.logger.debug{"CalendarItemReminder.ensure_pending_process checking reminder=#{calendar_item_reminder.inspect}. Item: #{calendar_item_reminder.calendar_item.display}, Calendar Item: #{calendar_item_reminder.calendar_item.inspect}"}
          
          is_expired = calendar_item_reminder.is_expired(now)

          Rails.logger.debug{"CalendarItemReminder.ensure_pending_process is_expired = #{is_expired}"}

          # Don't process a reminder that already has pendings outstanding because that means it has previously been
          # processed
          if calendar_item_reminder.calendar_item_reminder_pendings.count == 0
            
            if !calendar_item_reminder.calendar_item.calendar_item_time.nil?

              Rails.logger.debug{"CalendarItemReminder.ensure_pending_process calendar_item_time = #{calendar_item_reminder.calendar_item.calendar_item_time}"}
              
              cirt = calendar_item_reminder.threshold
          
              # A reminder pops if the current date is >= the reminder time
              if cirt <= now && !calendar_item_reminder.is_expired(now)
                
                Rails.logger.debug{"CalendarItemReminder.ensure_pending_process meets threshold of #{calendar_item_reminder.threshold_in_seconds.seconds} seconds from #{cirt}; #{cirt.utc} UTC, now: #{now} UTC"}
          
                # If there's a max_pending (often 1), then delete any pending
                # items beyond that amount
                new_pending = CalendarItemReminderPending.new(
                  calendar: calendar_item_reminder.calendar_item.calendar,
                  calendar_item: calendar_item_reminder.calendar_item,
                  calendar_item_reminder: calendar_item_reminder,
                  identity: calendar_item_reminder.identity
                )
                
                check_calendar_item = CalendarItem.where(id: calendar_item_reminder.calendar_item.id).take
                if !check_calendar_item.nil?
                  
                  check_calendar_item_reminder = CalendarItemReminder.where(id: calendar_item_reminder.id).take
                  if !check_calendar_item_reminder.nil?
                    
                    Rails.logger.debug{"CalendarItemReminder.ensure_pending_process potentially creating new pending reminder #{new_pending.inspect} ; #{new_pending.calendar_item.display} ; #{new_pending.calendar_item.inspect}"}
                    
                    can_save = true
                
                    if !calendar_item_reminder.max_pending.nil?
                      pendings_after = CalendarItemReminderPending.find_by_sql(
                        %{
                          SELECT calendar_item_reminder_pendings.*
                          FROM calendar_item_reminder_pendings
                            INNER JOIN calendar_items
                              ON calendar_item_reminder_pendings.calendar_item_id = calendar_items.id
                          WHERE calendar_item_reminder_pendings.calendar_id = #{calendar_item_reminder.calendar_item.calendar.id}
                            AND calendar_item_reminder_pendings.identity_id = #{identity.id}
                            AND calendar_items.model_class #{Myp.sanitize_with_null_for_conditions(calendar_item_reminder.calendar_item.model_class)}
                            AND calendar_items.model_id #{Myp.sanitize_with_null_for_conditions(calendar_item_reminder.calendar_item.model_id)}
                            AND calendar_items.calendar_item_time >= '#{calendar_item_reminder.calendar_item.calendar_item_time.to_s(:db)}'
                          ORDER BY calendar_items.calendar_item_time ASC
                        }
                      )
                      
                      pendings_after_count = pendings_after.count
                      
                      Rails.logger.debug{"CalendarItemReminder.ensure_pending_process pendings_after_count: #{pendings_after_count}"}
                      
                      if pendings_after_count >= calendar_item_reminder.max_pending
                        can_save = false
                        Rails.logger.debug{"CalendarItemReminder.ensure_pending_process no need to save this pending"}
                      end
                    end
                    
                    if can_save
                      new_pending.save!

                      Rails.logger.debug{"CalendarItemReminder.ensure_pending_process created new pending item #{new_pending.inspect}"}

                      item_class = calendar_item_reminder.calendar_item.find_model_class
                      
                      should_send_reminder = true
                      if item_class.respond_to?("should_send_reminder?")
                        if !item_class.should_send_reminder?
                          should_send_reminder = false
                        end
                      end

                      # Send any notifications about the new reminder
                      if should_send_reminder
                        send_reminder_notifications(user, new_pending)
                      end
                      
                      if item_class.respond_to?("handle_new_reminder?")
                        item_obj = calendar_item_reminder.calendar_item.find_model_object
                        if !item_obj.nil?
                          begin
                            item_obj.handle_new_reminder
                          rescue Exception => e
                            Myp.warn("CalendarItemReminder.ensure_pending_process Error handling new reminder", e)
                          end
                        end
                      end
                    end

                    if !calendar_item_reminder.max_pending.nil?
                      
                      pendings_result = CalendarItemReminderPending.find_by_sql(
                        %{
                          SELECT calendar_item_reminder_pendings.*
                          FROM calendar_item_reminder_pendings
                            INNER JOIN calendar_items
                              ON calendar_item_reminder_pendings.calendar_item_id = calendar_items.id
                          WHERE calendar_item_reminder_pendings.calendar_id = #{calendar_item_reminder.calendar_item.calendar.id}
                            AND calendar_item_reminder_pendings.identity_id = #{identity.id}
                            AND calendar_items.model_class #{Myp.sanitize_with_null_for_conditions(calendar_item_reminder.calendar_item.model_class)}
                            AND calendar_items.model_id #{Myp.sanitize_with_null_for_conditions(calendar_item_reminder.calendar_item.model_id)}
                          ORDER BY calendar_items.calendar_item_time ASC
                        }
                      )

                      Rails.logger.debug{"CalendarItemReminder.ensure_pending_process max_pending: #{calendar_item_reminder.max_pending}, existing pendings: #{pendings_result.count}"}
                      
                      pendings_result.each do |pr|
                        Rails.logger.debug{"CalendarItemReminder.ensure_pending_process checking can_save for pending: #{pr.inspect} ; #{pr.calendar_item_reminder.inspect} ; #{pr.calendar_item.inspect}"}
                      end
                      
                      number_to_delete = pendings_result.count - calendar_item_reminder.max_pending
                      
                      if number_to_delete > 0
                        
                        pendings_result.each do |pr|
                          Rails.logger.debug{"CalendarItemReminder.ensure_pending_process checking max_pending for pending: #{pr.inspect} ; #{pr.calendar_item_reminder.inspect} ; #{pr.calendar_item.inspect}"}
                        end
                        
                        pendings_result.first(number_to_delete).each do |x|

                          Rails.logger.debug{"CalendarItemReminder.ensure_pending_process destroying excessive reminder #{x.calendar_item_reminder.inspect}; #{x.inspect}; #{x.calendar_item.inspect}"}
                          
                          x.destroy!
                        end
                      end

                      Rails.logger.debug{"CalendarItemReminder.ensure_pending_process destroyed #{number_to_delete} pendings"}
                      
                    end
                  else
                    Myp.warn("Couldn't find CalendarItemReminder #{calendar_item_reminder.id} for #{new_pending.inspect}")
                  end
                else
                  Myp.warn("Couldn't find CalendarItem #{calendar_item_reminder.calendar_item.id} for #{new_pending.inspect}")
                end
              end
            end
          end
          
          if is_expired
            
            if calendar_item_reminder.calendar_item_reminder_pendings_unarchived.count > 0
              Rails.logger.debug{"CalendarItemReminder.ensure_pending_process reminder expired, deleting #{calendar_item_reminder.calendar_item_reminder_pendings_unarchived.count} pendings"}
            end
            
            calendar_item_reminder.calendar_item_reminder_pendings_unarchived.each do |calendar_item_reminder_pending|
              calendar_item_reminder_pending.archive!
            end
            
            # The model might want a callback on expiration
            if calendar_item_reminder.calendar_item.model_id.nil?
              calendar_item_class = calendar_item_reminder.calendar_item.find_model_class
              if calendar_item_class.respond_to?("handle_expired_reminder")
                Rails.logger.debug{"CalendarItemReminder.ensure_pending_process calling handle_expired_reminder on class"}
                calendar_item_class.handle_expired_reminder
              end
            else
              calendar_item_object = calendar_item_reminder.calendar_item.find_model_object
              
              Rails.logger.debug{"CalendarItemReminder.ensure_pending_process checking calendar_item_object = #{calendar_item_object.inspect}"}

              if !calendar_item_object.nil? && calendar_item_object.respond_to?("handle_expired_reminder")
                Rails.logger.debug{"CalendarItemReminder.ensure_pending_process calling handle_expired_reminder on object"}
                calendar_item_object.handle_expired_reminder
              end
            end
          end
        else
          Myp.warn("CalendarItemReminder.ensure_pending_process Destroying invalid calendar item with identity: #{calendar_item_reminder.calendar_item.identity_id}, model_class: #{calendar_item_reminder.calendar_item.model_class}, model_id: #{calendar_item_reminder.calendar_item.model_id}")
          calendar_item_reminder.calendar_item.destroy!
        end
        
        Rails.logger.debug{"CalendarItemReminder.ensure_pending_process finished checking reminder"}
    end

    Rails.logger.debug("CalendarItemReminder.ensure_pending_process ensure_pending_process end")
  end
  
  def self.ensure_pending(user)
    
    Rails.logger.debug("CalendarItemReminder.ensure_pending start #{user.id}")

    # Error "current transaction is aborted, commands ignored until end of transaction block" is caused by a previous transaction error
    executed = Myp.try_with_database_advisory_lock(Myp::DB_LOCK_CALENDAR_ITEM_REMINDERS, user.id) do
      user.identities.each do |identity|
        MyplaceonlineExecutionContext.do_full_context(user, identity) do
          ensure_pending_process(user, identity)
        end
      end
    end

    if !executed
      Rails.logger.info("CalendarItemReminder.ensure_pending could not lock (#{Myp::DB_LOCK_CALENDAR_ITEM_REMINDERS}, #{user.id})")
    end

    Rails.logger.debug("CalendarItemReminder.ensure_pending end")
  end
  
  def self.schedule_ensure_pending(user)
    ApplicationJob.perform(UpdateCalendarJob, user)
  end
  
  MAX_MESSAGE_LENGTH = 140
  MAX_NUM_MESSAGES = 3

  def self.send_reminder_notifications(user, pending_item)
    Rails.logger.info("CalendarItemReminder.send_reminder_notifications notifying #{user} for #{pending_item}")
    
    begin

      begin
        link = Myp.root_url + "/c/" + pending_item.id.to_s
      rescue Exception => e1
        # http://stackoverflow.com/a/35832218/5657303
        link = "http://localhost:3000/c/" + pending_item.id.to_s
      end
      
      chars_available = (MAX_MESSAGE_LENGTH * MAX_NUM_MESSAGES) - link.length - 4 # 1 for a space before the link, and 3 for an ellipses
      
      message = I18n.t(
        "myplaceonline.calendar_item_reminders.text_message",
        time: Myp.display_datetime_short(pending_item.calendar_item.calendar_item_time, User.current_user),
        display: pending_item.calendar_item.display
      )
      
      Rails.logger.debug("CalendarItemReminder.send_reminder_notifications message #{message}, #{link}")
      
      if message.length > chars_available
        message = message[0..chars_available - 1] + "..."
      end
      
      message += " " + link
      
      Rails.logger.debug("CalendarItemReminder.send_reminder_notifications final message #{message}")
      
      user.send_sms(message)
      
    rescue Exception => e
      Myp.warn("Could not process send_reminder_notifications #{user.id}, #{pending_item.id}: #{Myp.error_details(e)}")
    end
    
    Rails.logger.debug("CalendarItemReminder.send_reminder_notifications end")
  end
  
  def threshold_in_seconds
    if self.threshold_amount.nil?
      0
    elsif self.threshold_type.nil? # assume seconds
      self.threshold_amount
    elsif self.threshold_type == Myp::TIME_DURATION_SECONDS
      self.threshold_amount
    elsif self.threshold_type == Myp::TIME_DURATION_MINUTES
      self.threshold_amount * 60
    elsif self.threshold_type == Myp::TIME_DURATION_HOURS
      self.threshold_amount * 60 * 60
    elsif self.threshold_type == Myp::TIME_DURATION_DAYS
      self.threshold_amount * 60 * 60 * 24
    elsif self.threshold_type == Myp::TIME_DURATION_WEEKS
      self.threshold_amount * 60 * 60 * 24 * 7
    elsif self.threshold_type == Myp::TIME_DURATION_MONTHS
      self.threshold_amount * 60 * 60 * 24 * 7 * 4.35
    elsif self.threshold_type == Myp::TIME_DURATION_YEARS
      self.threshold_amount * 60 * 60 * 24 * 7 * 4.35 * 12
    else
      raise "TODO (#{self.id}; #{self.threshold_amount}; #{self.threshold_type})"
    end
  end
  
  def expires_in_seconds
    if expire_amount.nil?
      0
    elsif expire_type.nil? # assume seconds
      expire_amount
    elsif expire_type == Myp::TIME_DURATION_SECONDS
      expire_amount
    else
      raise "TODO (#{self.id}; #{self.expire_amount}; #{self.expire_type})"
    end
  end
  
  def is_expired(dt)
    result = false
    if !expire_amount.nil?
      if !calendar_item.calendar_item_time.nil? && calendar_item.calendar_item_time + expires_in_seconds.seconds < dt
        result = true
      end
    end
    Rails.logger.debug("CalendarItemReminder.is_expired result: #{result}")
    result
  end
  
  def threshold
    if !self.calendar_item.nil? && !self.calendar_item.calendar_item_time.nil? && !self.threshold_in_seconds.nil?
      self.calendar_item.calendar_item_time - self.threshold_in_seconds.seconds
    else
      nil
    end
  end
  
  def calendar_item_reminder_pendings_unarchived
    self.calendar_item_reminder_pendings.to_a.delete_if{|x| x.archived?}
  end
end
