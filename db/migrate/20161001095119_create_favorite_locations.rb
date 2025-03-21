class CreateFavoriteLocations < ActiveRecord::Migration
  def change
    create_table :favorite_locations do |t|
      t.references :location, index: true, foreign_key: true
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
