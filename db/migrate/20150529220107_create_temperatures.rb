class CreateTemperatures < ActiveRecord::Migration
  def change
    create_table :temperatures do |t|
      t.datetime :measured
      t.decimal :measured_temperature, precision: 10, scale: 2
      t.string :measurement_source
      t.integer :temperature_type
      t.references :identity, index: true

      t.timestamps
    end
  end
end
