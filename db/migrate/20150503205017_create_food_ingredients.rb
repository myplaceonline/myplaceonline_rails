class CreateFoodIngredients < ActiveRecord::Migration
  def change
    create_table :food_ingredients do |t|
      t.references :identity, index: true
      t.references :parent_food, index: true
      t.references :food, index: true

      t.timestamps
    end
  end
end
