class FoodInformation < ApplicationRecord
  belongs_to :usda_food, class_name: "UsdaNutrientDatabase::Food", foreign_key: :nutrient_databank_number
  belongs_to :identity
end
