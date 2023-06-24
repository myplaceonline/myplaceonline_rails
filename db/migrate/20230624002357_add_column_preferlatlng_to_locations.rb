class AddColumnPreferlatlngToLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :prefer_latlng, :boolean
  end
end
