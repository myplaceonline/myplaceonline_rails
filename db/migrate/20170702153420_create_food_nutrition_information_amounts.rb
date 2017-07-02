class CreateFoodNutritionInformationAmounts < ActiveRecord::Migration[5.1]
  def change
    create_table :food_nutrition_information_amounts do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.integer :measurement_type
      t.references :nutrient, foreign_key: true
      t.references :food_nutrition_information, foreign_key: true, index: false
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
    add_index :food_nutrition_information_amounts, :food_nutrition_information_id, name: "fnia_on_fni"
  end
end
