class CreateRecreationalVehicleMeasurements < ActiveRecord::Migration
  def change
    create_table :recreational_vehicle_measurements do |t|
      t.string :measurement_name
      t.integer :measurement_type
      t.decimal :width, precision: 10, scale: 2
      t.decimal :height, precision: 10, scale: 2
      t.decimal :depth, precision: 10, scale: 2
      t.text :notes
      t.references :owner, index: true
      t.references :recreational_vehicle

      t.timestamps null: true
    end
  end
end
