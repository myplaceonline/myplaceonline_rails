class AddColumnUnlimitedTimeParkingToCampLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :camp_locations, :unlimited_time_parking, :boolean
  end
end
