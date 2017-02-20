class CreateDriverLicenses < ActiveRecord::Migration[5.0]
  def change
    create_table :driver_licenses do |t|
      t.string :driver_license_identifier
      t.date :driver_license_expires
      t.date :driver_license_issued
      t.string :sub_region1
      t.references :address, foreign_key: false
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
    add_foreign_key :driver_licenses, :locations, column: :address_id
  end
end
