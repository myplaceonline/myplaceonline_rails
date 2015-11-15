class AddOriginalDueDateToDueItems < ActiveRecord::Migration
  def change
    add_column :due_items, :original_due_date, :datetime
    SnoozedDueItem.destroy_all
  end
end
