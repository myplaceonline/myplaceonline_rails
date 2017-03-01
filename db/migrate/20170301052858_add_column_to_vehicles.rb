class AddColumnToVehicles < ActiveRecord::Migration[5.0]
  def change
    add_column :vehicles, :bought_miles, :decimal, precision: 10, scale: 2
  end
end
