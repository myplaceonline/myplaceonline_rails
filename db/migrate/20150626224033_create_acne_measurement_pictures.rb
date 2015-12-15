class CreateAcneMeasurementPictures < ActiveRecord::Migration
  def change
    create_table :acne_measurement_pictures do |t|
      t.references :acne_measurement, index: true
      t.references :identity_file, index: true
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
