class AddColumnsToDrinks < ActiveRecord::Migration
  def change
    add_column :meal_drinks, :drink_servings, :decimal, precision: 10, scale: 2
  end
end
