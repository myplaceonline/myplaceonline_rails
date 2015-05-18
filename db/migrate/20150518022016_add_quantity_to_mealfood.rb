class AddQuantityToMealfood < ActiveRecord::Migration
  def change
    add_column :meal_foods, :food_servings, :decimal, precision: 10, scale: 2
    remove_column :foods, :food_servings
  end
end
