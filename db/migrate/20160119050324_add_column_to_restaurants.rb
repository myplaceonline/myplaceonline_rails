class AddColumnToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :visited, :boolean
  end
end
