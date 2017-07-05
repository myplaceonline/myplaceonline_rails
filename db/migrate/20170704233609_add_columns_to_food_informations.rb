class AddColumnsToFoodInformations < ActiveRecord::Migration[5.1]
  def change
    remove_column :food_informations, :usda_foods_id
    remove_column :food_informations, :nutrient_databank_number
    add_column :usda_weights, :id, :primary_key, first: true
    add_reference :food_informations, :usda_weight, foreign_key: true, index: true
  end
end
