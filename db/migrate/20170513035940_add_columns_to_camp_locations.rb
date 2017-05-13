class AddColumnsToCampLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :camp_locations, :chance_high_wind, :boolean
  end
end
