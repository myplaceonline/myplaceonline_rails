class AddColumnCostPerNightToCampLocations < ActiveRecord::Migration[5.1]
  def change
    add_column :camp_locations, :nightly_cost, :decimal, precision: 10, scale: 2
  end
end
