class FoodNutritionInformationAmount < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  
  MEASUREMENT_TYPE_NUMBER = 0
  MEASUREMENT_TYPE_PERCENT = 1
  MEASUREMENT_TYPE_PER_100_GRAMS = 2

  MEASUREMENT_TYPES = [
    ["myplaceonline.food_nutrition_information_amounts.measurement_types.number", MEASUREMENT_TYPE_NUMBER],
    ["myplaceonline.food_nutrition_information_amounts.measurement_types.percent", MEASUREMENT_TYPE_PERCENT],
    ["myplaceonline.food_nutrition_information_amounts.measurement_types.per_100g", MEASUREMENT_TYPE_PER_100_GRAMS],
  ]
  
  def self.properties
    [
      { name: :amount, type: ApplicationRecord::PROPERTY_TYPE_DECIMAL },
      { name: :measurement_type, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :nutrient, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  validates :nutrient, presence: true
  
  def display
    nutrient.display
  end

  child_property(name: :nutrient)
  
  def self.params
    [
      :id,
      :_destroy,
      :amount,
      :measurement_type,
      :notes,
      nutrient_attributes: Nutrient.params
    ]
  end
end
