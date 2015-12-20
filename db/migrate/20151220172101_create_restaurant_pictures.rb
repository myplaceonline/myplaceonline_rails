class CreateRestaurantPictures < ActiveRecord::Migration
  def change
    create_table :restaurant_pictures do |t|
      t.references :restaurant, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :owner, index: true, foreign_key: false

      t.timestamps null: false
    end
    add_foreign_key :restaurant_pictures, :identities, column: :owner_id
  end
end
