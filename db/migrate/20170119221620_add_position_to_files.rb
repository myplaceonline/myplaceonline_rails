class AddPositionToFiles < ActiveRecord::Migration[5.0]
  def change
    add_column :acne_measurement_pictures, :position, :integer
    add_column :apartment_pictures, :position, :integer
    add_column :bar_pictures, :position, :integer
    add_column :concert_pictures, :position, :integer
    add_column :identity_pictures, :position, :integer
    add_column :location_pictures, :position, :integer
    add_column :passport_pictures, :position, :integer
    add_column :recipe_pictures, :position, :integer
    add_column :recreational_vehicle_pictures, :position, :integer
    add_column :restaurant_pictures, :position, :integer
    add_column :story_pictures, :position, :integer
    add_column :trek_pictures, :position, :integer
    add_column :vehicle_pictures, :position, :integer
  end
end
