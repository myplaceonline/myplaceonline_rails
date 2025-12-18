class AddColumnsToDesiredLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :desired_locations, :notes, :text
  end
end
