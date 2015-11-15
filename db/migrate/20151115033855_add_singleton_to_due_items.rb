class AddSingletonToDueItems < ActiveRecord::Migration
  def change
    add_column :due_items, :is_date_arbitrary, :boolean
  end
end
