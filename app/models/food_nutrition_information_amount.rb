class FoodNutritionInformationAmount < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  MEASUREMENT_TYPES = [
    ["myplaceonline.food_nutrition_information_amounts.measurement_types.number", 0],
    ["myplaceonline.food_nutrition_information_amounts.measurement_types.percent", 1],
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
      :amount,
      :measurement_type,
      :notes,
      nutrient_attributes: Nutrient.params
    ]
  end
end
