class CalendarItemReminder < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :calendar_item

  has_many :calendar_item_reminder_pendings, :dependent => :destroy
  
  def self.ensure_pending(user)
    CalendarItemReminder
      .includes(:calendar_item_reminder_pendings, :calendar_item)
      .where(identity: user.primary_identity)
      .each do |calendar_item_reminder|

        # Only check reminders that don't already have items pending
        if calendar_item_reminder.calendar_item_reminder_pendings.count == 0
          if !calendar_item_reminder.calendar_item.calendar_item_time.nil?
            if calendar_item_reminder.calendar_item.calendar_item_time - calendar_item_reminder.threshold_in_seconds.seconds <= user.time_now
              CalendarItemReminderPending.new(
                calendar_item_reminder: calendar_item_reminder,
                calendar: calendar_item_reminder.calendar_item.calendar,
                calendar_item: calendar_item_reminder.calendar_item,
                identity: user.primary_identity
              ).save!
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
end
