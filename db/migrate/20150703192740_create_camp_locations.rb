class CreateCampLocations < ActiveRecord::Migration
  def change
    create_table :camp_locations do |t|
      t.references :location, index: true
      t.boolean :vehicle_parking
      t.boolean :free
      t.boolean :sewage
      t.boolean :fresh_water
      t.boolean :electricity
      t.boolean :internet
      t.boolean :trash
      t.boolean :shower
      t.boolean :bathroom
      t.integer :noise_level
      t.integer :rating
      t.boolean :overnight_allowed
      t.text :notes
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
