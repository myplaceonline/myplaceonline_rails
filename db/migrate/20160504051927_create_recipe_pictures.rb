class CreateRecipePictures < ActiveRecord::Migration
  def change
    create_table :recipe_pictures do |t|
      t.references :recipe, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
