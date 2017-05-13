class AddColumns2ToCampingLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :camp_locations, :birds_chirping, :boolean
    add_column :camp_locations, :near_busy_road, :boolean
  end
end
