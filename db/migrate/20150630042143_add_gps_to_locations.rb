class AddGpsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :latitude, :decimal, precision: 10, scale: 2
    add_column :locations, :longitude, :decimal, precision: 10, scale: 2
  end
end
