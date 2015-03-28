class CreateIdentityDriversLicenses < ActiveRecord::Migration
  def change
    create_table :identity_drivers_licenses do |t|
      t.string :identifier
      t.string :region
      t.string :sub_region1
      t.date :expires
      t.references :ref, index: true

      t.timestamps
    end
  end
end
