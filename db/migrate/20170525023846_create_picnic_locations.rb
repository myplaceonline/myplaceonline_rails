class CreatePicnicLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :picnic_locations do |t|
      t.references :location, foreign_key: true
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
