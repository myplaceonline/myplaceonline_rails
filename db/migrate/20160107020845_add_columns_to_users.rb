class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :experimental_categories, :boolean
  end
end
