class AddColsToCampLocations < ActiveRecord::Migration
  def change
    add_column :camp_locations, :boondocking, :boolean
    add_column :camp_locations, :cell_phone_reception, :boolean
    add_column :camp_locations, :cell_phone_data, :boolean
  end
end
