class AddColumnsToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :expires, :date
  end
end
