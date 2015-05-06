class CreateAcneMeasurements < ActiveRecord::Migration
  def change
    create_table :acne_measurements do |t|
      t.datetime :measurement_datetime
      t.string :acne_location
      t.integer :total_pimples
      t.integer :new_pimples
      t.integer :worrying_pimples
      t.references :identity, index: true

      t.timestamps
    end
  end
end
