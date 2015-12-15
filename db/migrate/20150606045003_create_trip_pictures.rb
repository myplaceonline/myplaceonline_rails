class CreateTripPictures < ActiveRecord::Migration
  def change
    create_table :trip_pictures do |t|
      t.references :identity, index: true
      t.references :trip, index: true
      t.references :identity_file, index: true

      t.timestamps null: true
    end
  end
end
