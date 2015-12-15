class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :name
      t.text :notes
      t.date :owned_start
      t.date :owned_end
      t.string :vin
      t.string :manufacturer
      t.string :model
      t.integer :year
      t.string :color
      t.string :license_plate
      t.string :region
      t.string :sub_region1
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
