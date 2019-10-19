class AddColumnBathroomCodeToLocations < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :bathroom_code, :text
  end
end
