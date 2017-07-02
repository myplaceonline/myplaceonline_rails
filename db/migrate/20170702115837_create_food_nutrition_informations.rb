class CreateFoodNutritionInformations < ActiveRecord::Migration[5.1]
  def change
    create_table :food_nutrition_informations do |t|
      t.decimal :serving_size, precision: 10, scale: 2
      t.decimal :servings_per_container, precision: 10, scale: 2
      t.decimal :calories_per_serving, precision: 10, scale: 2
      t.decimal :calories_per_serving_from_fat, precision: 10, scale: 2
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
