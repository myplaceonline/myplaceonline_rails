class AddColumnDetourToGasStations < ActiveRecord::Migration[5.2]
  def change
    add_column :gas_stations, :detour_from, :string
    add_column :gas_stations, :detour_time, :string
  end
end
