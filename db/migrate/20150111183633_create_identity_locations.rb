class CreateIdentityLocations < ActiveRecord::Migration
  def change
    create_table :identity_locations do |t|
      t.references :location, index: true
      t.references :ref, index: true

      t.timestamps null: true
    end
  end
end
