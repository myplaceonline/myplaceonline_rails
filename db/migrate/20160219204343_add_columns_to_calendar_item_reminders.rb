class AddColumnsToCalendarItemReminders < ActiveRecord::Migration
  def change
    add_column :calendar_item_reminders, :max_pending, :integer
  end
end
