class CreateFoodNutrientInformations < ActiveRecord::Migration[5.1]
  def change
    create_table :food_nutrient_informations do |t|
      t.string :nutrient_name
      t.string :usda_nutrient_nutrient_number
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
