class DietFood < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  FOOD_TYPES = [
    ["myplaceonline.diet_foods.food_types.breakfast", 0],
    ["myplaceonline.diet_foods.food_types.lunch", 1],
    ["myplaceonline.diet_foods.food_types.dinner", 2],
    ["myplaceonline.diet_foods.food_types.snack", 3],
  ]
  
  def self.properties
    [
      { name: :food, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :quantity, type: ApplicationRecord::PROPERTY_TYPE_DECIMAL },
    ]
  end

  validates :food, presence: true
  
  belongs_to :diet
  
  def display
    "#{food.display} x#{self.quantity_with_fallback}"
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

  def quantity_with_fallback(default_quantity: 1)
    if !self.quantity.nil?
      self.quantity
    else
      default_quantity
    end
  end
end
