class AddColumnsToFoodNutrientInformation < ActiveRecord::Migration[5.1]
  def change
    add_column :food_nutrition_informations, :serving_size_type, :integer
  end
end
