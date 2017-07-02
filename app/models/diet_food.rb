class DietFood < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  FOOD_TYPES = [
    ["myplaceonline.diet_foods.food_types.breakfast", 0],
    ["myplaceonline.diet_foods.food_types.lunch", 1],
    ["myplaceonline.diet_foods.food_types.dinner", 2],
  ]
  
  def self.properties
    [
      { name: :food, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :quantity, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
    ]
  end

  validates :food, presence: true
  
  def display
    food.display
  end

  child_property(name: :food)

  def self.params
    [
      :id,
      :_destroy,
      :quantity,
      :food_type,
      food_attributes: Food.params
    ]
  end

end
