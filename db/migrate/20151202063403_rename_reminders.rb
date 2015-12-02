class RenameReminders < ActiveRecord::Migration
  def change
    rename_table :reminders, :repeats
  end
end
