class AddRvToVehicle < ActiveRecord::Migration
  def change
    add_reference :vehicles, :recreational_vehicle
  end
end
