class CreateFavoriteProducts < ActiveRecord::Migration
  def change
    create_table :favorite_products do |t|
      t.string :product_name
      t.text :notes
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
