class AddColumnsToCalendarItemReminderPendings < ActiveRecord::Migration
  def change
    add_reference :calendar_item_reminder_pendings, :calendar, index: true, foreign_key: true
    add_reference :calendar_item_reminder_pendings, :calendar_item, index: true, foreign_key: true
    add_column :calendar_items, :context_info, :string
  end
end
