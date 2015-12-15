class CreateRecreationalVehicles < ActiveRecord::Migration
  def change
    create_table :recreational_vehicles do |t|
      t.string :rv_name
      t.string :vin
      t.string :manufacturer
      t.string :model
      t.integer :year
      t.decimal :price, precision: 10, scale: 2
      t.decimal :msrp, precision: 10, scale: 2
      t.date :purchased
      t.date :owned_start
      t.date :owned_end
      t.text :notes
      t.references :location_purchased, index: true
      t.references :vehicle, index: true
      t.decimal :wet_weight, precision: 10, scale: 2
      t.integer :sleeps
      t.integer :dimensions_type
      t.decimal :exterior_length, precision: 10, scale: 2
      t.decimal :exterior_width, precision: 10, scale: 2
      t.decimal :exterior_height, precision: 10, scale: 2
      t.decimal :exterior_height_over, precision: 10, scale: 2
      t.decimal :interior_height, precision: 10, scale: 2
      t.integer :liquid_capacity_type
      t.integer :fresh_tank
      t.integer :grey_tank
      t.integer :black_tank
      t.date :warranty_ends
      t.integer :water_heater
      t.integer :propane
      t.integer :volume_type
      t.integer :weight_type
      t.integer :refrigerator
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
