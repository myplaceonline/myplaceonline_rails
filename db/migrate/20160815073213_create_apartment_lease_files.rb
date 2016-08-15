class CreateApartmentLeaseFiles < ActiveRecord::Migration
  def change
    create_table :apartment_lease_files do |t|
      t.references :apartment_lease, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
