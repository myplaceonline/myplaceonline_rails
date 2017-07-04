class FoodInformation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :food_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

  belongs_to :usda_food, class_name: "UsdaNutrientDatabase::Food", foreign_key: :nutrient_databank_number

  validates :food_name, presence: true
  
  def display
    food_name
  end
end
