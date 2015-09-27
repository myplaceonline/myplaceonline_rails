class AddColsToRecreationalVehicles < ActiveRecord::Migration
  def change
    add_column :recreational_vehicles, :floor_length, :decimal, precision: 10, scale: 2
  end
end
