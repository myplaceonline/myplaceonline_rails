class CreateRecreationalVehicleServiceFiles < ActiveRecord::Migration
  def change
    create_table :recreational_vehicle_service_files do |t|
      t.references :recreational_vehicle_service, index: {:name => "index_rvservicefiles_rvserviceid"}, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
