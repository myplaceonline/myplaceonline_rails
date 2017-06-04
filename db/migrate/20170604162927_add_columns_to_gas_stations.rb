class AddColumnsToGasStations < ActiveRecord::Migration[5.1]
  def change
    add_column :gas_stations, :notes, :text
    add_column :gas_stations, :rv_dump_station, :boolean
  end
end
