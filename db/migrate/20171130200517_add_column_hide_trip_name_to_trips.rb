class AddColumnHideTripNameToTrips < ActiveRecord::Migration[5.1]
  def change
    add_column :trips, :hide_trip_name, :boolean
  end
end
