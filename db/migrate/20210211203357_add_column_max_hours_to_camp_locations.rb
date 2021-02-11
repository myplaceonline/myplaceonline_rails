class AddColumnMaxHoursToCampLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :camp_locations, :maxhours, :decimal, precision: 10, scale: 2
  end
end
