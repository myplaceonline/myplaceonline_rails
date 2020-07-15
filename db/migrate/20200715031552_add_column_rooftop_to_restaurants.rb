class AddColumnRooftopToRestaurants < ActiveRecord::Migration[5.2]
  def change
    add_column :restaurants, :rooftop, :boolean
  end
end
