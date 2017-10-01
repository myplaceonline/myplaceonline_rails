class AddColumnsToReminders < ActiveRecord::Migration[5.1]
  def change
    add_reference :reminders, :calendar_item, foreign_key: true
  end
end
