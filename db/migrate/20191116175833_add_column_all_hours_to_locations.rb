class AddColumnAllHoursToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :allhours, :boolean
  end
end
