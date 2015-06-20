class AddSlideOutWidthsToRecreationalVehicles < ActiveRecord::Migration
  def change
    add_column :recreational_vehicles, :slideouts_extra_width, :decimal, precision: 10, scale: 2
  end
end
