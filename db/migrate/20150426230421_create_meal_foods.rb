class CreateMealFoods < ActiveRecord::Migration
  def change
    create_table :meal_foods do |t|
      t.references :identity, index: true
      t.references :meal, index: true
      t.references :food, index: true

      t.timestamps
    end
  end
end
