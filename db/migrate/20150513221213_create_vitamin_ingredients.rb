class CreateVitaminIngredients < ActiveRecord::Migration
  def change
    create_table :vitamin_ingredients do |t|
      t.references :identity, index: true
      t.references :parent_vitamin, index: true
      t.references :vitamin, index: true

      t.timestamps
    end
  end
end
