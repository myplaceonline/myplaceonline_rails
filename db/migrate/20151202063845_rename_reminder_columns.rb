class RenameReminderColumns < ActiveRecord::Migration
  def change
    rename_column :apartment_trash_pickups, :reminder_id, :repeat_id
    rename_column :events, :reminder_id, :repeat_id
  end
end
