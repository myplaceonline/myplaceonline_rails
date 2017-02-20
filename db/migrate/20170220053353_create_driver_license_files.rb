class CreateDriverLicenseFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :driver_license_files do |t|
      t.references :driver_license, foreign_key: true
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
