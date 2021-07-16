class CreateRestaurantDishes < ActiveRecord::Migration[6.1]
  def change
    create_table :restaurant_dishes do |t|
      t.string :dish_name
      t.references :restaurant, foreign_key: true
      t.decimal :cost, precision: 10, scale: 2
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.boolean :is_public
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
