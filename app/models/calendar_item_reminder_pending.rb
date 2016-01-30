class CalendarItemReminderPending < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :calendar_item_reminder
  belongs_to :calendar_item
  belongs_to :calendar
end
