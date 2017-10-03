class AddColumnReminderToDietFoods < ActiveRecord::Migration[5.1]
  def change
    add_reference :diet_foods, :reminder, foreign_key: true
  end
end
