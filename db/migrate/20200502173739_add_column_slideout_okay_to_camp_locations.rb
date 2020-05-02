class AddColumnSlideoutOkayToCampLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :camp_locations, :slideout_okay, :boolean
  end
end
