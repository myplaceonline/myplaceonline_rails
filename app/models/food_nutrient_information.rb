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
  
  def nutrient_units
    case self.usda_nutrient.units
    when "g"
      Nutrient::MEASUREMENT_GRAMS
    when "mg"
      Nutrient::MEASUREMENT_MILLI_GRAMS
    when "µg"
      Nutrient::MEASUREMENT_MICRO_GRAMS
    when "µg"
      Nutrient::MEASUREMENT_MICRO_GRAMS_RAE
    when "IU"
      Nutrient::MEASUREMENT_IUS
    else
      raise "TODO"
    end
  end
end
