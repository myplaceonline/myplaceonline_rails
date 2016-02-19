class AddWebsiteToDesiredLocations < ActiveRecord::Migration
  def change
    add_reference :desired_locations, :website, index: true, foreign_key: true
  end
end
