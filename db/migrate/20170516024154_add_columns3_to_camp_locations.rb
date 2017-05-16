class AddColumns3ToCampLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :camp_locations, :level_ground, :boolean
  end
end
