class AddOriginalDueDateToCompleteDueItems < ActiveRecord::Migration
  def change
    add_column :complete_due_items, :original_due_date, :datetime
  end
end
