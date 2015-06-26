class CreateVehiclePictures < ActiveRecord::Migration
  def change
    create_table :vehicle_pictures do |t|
      t.references :vehicle, index: true
      t.references :identity_file, index: true
      t.references :identity, index: true

      t.timestamps
    end
  end
end
