class CreateRecreationalVehiclePictures < ActiveRecord::Migration
  def change
    create_table :recreational_vehicle_pictures do |t|
      t.references :recreational_vehicle, index: true
      t.references :identity_file, index: true
      t.references :identity, index: true

      t.timestamps
    end
  end
end
