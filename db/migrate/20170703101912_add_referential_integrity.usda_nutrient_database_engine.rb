# This migration comes from usda_nutrient_database_engine (originally 9)
class AddReferentialIntegrity < ActiveRecord::Migration[5.1]
  def change
    remove_index :usda_nutrients, :nutrient_number
    add_index :usda_nutrients, :nutrient_number, unique: true

    remove_index :usda_source_codes, :code
    add_index :usda_source_codes, :code, unique: true

    remove_index :usda_food_groups, :code
    add_index :usda_food_groups, :code, unique: true

    remove_index :usda_foods, :nutrient_databank_number
    add_index :usda_foods, :nutrient_databank_number, unique: true

    add_index :usda_foods_nutrients, [
      :nutrient_databank_number,
      :nutrient_number
    ],
    unique: true,
    name: "index_usda_foods_nutrients_on_databank_number_and_number"
  end
end
