class CreateFavoriteProductLinks < ActiveRecord::Migration
  def change
    create_table :favorite_product_links do |t|
      t.references :favorite_product, index: true, foreign_key: true
      t.references :owner, index: true, foreign_key: false
      t.string :link, limit: 2000

      t.timestamps null: false
    end
    add_foreign_key :favorite_product_links, :identities, column: :owner_id
  end
end
