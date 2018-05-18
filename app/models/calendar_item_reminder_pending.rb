class CalendarItemReminderPending < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :calendar_item_reminder
  belongs_to :calendar_item
  belongs_to :calendar

  def self.pending_items(user, calendar)
    items = CalendarItemReminderPending
      .includes(:calendar, :calendar_item)
      .where(
        identity: user.current_identity,
        calendar: calendar
      )
      .order("created_at DESC").to_a
    items.sort! do |x, y|
      if x.calendar_item.calendar_item_time.nil? && y.calendar_item.calendar_item_time.nil?
        0
      elsif y.calendar_item.calendar_item_time.nil?
        -1
      elsif x.calendar_item.calendar_item_time.nil?
        1
      else 
        x.calendar_item.calendar_item_time <=> y.calendar_item.calendar_item_time
      end
    end
    items = items.delete_if{|x| x.archived?}
    items
  end

  def display
    I18n.t("myplaceonline.calendar_item_reminder_pendings.display")
  end
end
