class CreateLocationPictures < ActiveRecord::Migration
  def change
    create_table :location_pictures do |t|
      t.references :location, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
