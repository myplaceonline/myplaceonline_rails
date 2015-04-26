class CreateMealDrinks < ActiveRecord::Migration
  def change
    create_table :meal_drinks do |t|
      t.references :identity, index: true
      t.references :meal, index: true
      t.references :drink, index: true

      t.timestamps
    end
  end
end
