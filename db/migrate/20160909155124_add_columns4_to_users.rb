class AddColumns4ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :recently_visited_categories, :integer
    add_column :users, :most_visited_categories, :integer
    add_column :users, :most_visited_items, :integer
  end
end
