class FoodNutrientInformation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  
  belongs_to :usda_nutrient, class_name: "UsdaNutrientDatabase::Nutrient", foreign_key: :usda_nutrient_nutrient_number

  validates :nutrient_name, presence: true
  
  def display
    nutrient_name
  end

  def self.allow_super_user_search?
    true
  end
end
