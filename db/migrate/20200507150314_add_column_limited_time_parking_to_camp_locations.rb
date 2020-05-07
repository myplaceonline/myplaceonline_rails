class AddColumnLimitedTimeParkingToCampLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :camp_locations, :limited_time_parking, :boolean
  end
end
