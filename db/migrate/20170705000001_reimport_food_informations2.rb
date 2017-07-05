class ReimportFoodInformations2 < ActiveRecord::Migration[5.1]
  def change
    remove_column :food_informations, :usda_food_id
    remove_column :food_informations, :usda_weight_id
    remove_column :usda_foods, :id
    remove_column :usda_weights, :id
    add_column :food_informations, :usda_food_nutrient_databank_number, :string
    add_column :food_informations, :usda_weight_nutrient_databank_number, :string
    add_column :food_informations, :usda_weight_nutrient_sequence_number, :string
    rename_column :food_informations, :usda_weight_nutrient_sequence_number, :usda_weight_sequence_number
  end
end
