class AddServingsToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :food_servings, :decimal, precision: 10, scale: 2
  end
end
