class CreateVehicleServiceFiles < ActiveRecord::Migration
  def change
    create_table :vehicle_service_files do |t|
      t.references :vehicle_service, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
