class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :recipe
      t.references :identity, index: true

      t.timestamps
    end
  end
end
