class AddCaboverLengthToRecreationalVehicles < ActiveRecord::Migration
  def change
    add_column :recreational_vehicles, :exterior_length_over, :decimal, precision: 10, scale: 2
  end
end
