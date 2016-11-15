class AddColumnsToIdentityLocations < ActiveRecord::Migration
  def change
    add_column :identity_locations, :secondary, :boolean
  end
end
