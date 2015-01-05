class AddPostalCodeToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :postal_code, :string
  end
end
