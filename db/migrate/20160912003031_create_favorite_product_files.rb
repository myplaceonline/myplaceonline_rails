class CreateFavoriteProductFiles < ActiveRecord::Migration
  def change
    create_table :favorite_product_files do |t|
      t.references :favorite_product, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
