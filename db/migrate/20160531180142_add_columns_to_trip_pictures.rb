class AddColumnsToTripPictures < ActiveRecord::Migration
  def change
    add_column :trip_pictures, :position, :integer
  end
end
