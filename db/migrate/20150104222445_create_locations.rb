class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :region
      t.string :sub_region1
      t.string :sub_region2
      t.references :identity, index: true

      t.timestamps
    end
  end
end
