class CalendarItemReminderPending < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :calendar_item_reminder
  belongs_to :calendar_item
  belongs_to :calendar

  def self.pending_items(user, calendar)
    items = CalendarItemReminderPending
      .includes(:calendar, :calendar_item)
      .where(
        identity: user.primary_identity,
        calendar: calendar
      )
      .order("created_at DESC").to_a
    items.sort!{|x, y| x.calendar_item.calendar_item_time <=> y.calendar_item.calendar_item_time }
    items
  end
end
