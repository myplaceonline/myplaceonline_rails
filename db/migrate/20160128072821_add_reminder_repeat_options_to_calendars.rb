class AddReminderRepeatOptionsToCalendars < ActiveRecord::Migration
  def change
    add_column :calendars, :reminder_repeat_amount, :integer
    add_column :calendars, :reminder_repeat_type, :integer
  end
end
