class ConsumedFood < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :consumed_food_time, type: ApplicationRecord::PROPERTY_TYPE_DATETIME },
      { name: :food, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :quantity, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
    ]
  end

  validates :consumed_food_time, presence: true
  validates :food, presence: true
  
  def display
    "#{food.display} x#{self.quantity_with_fallback}"
  end

  child_property(name: :food)

  def self.params
    [
      :id,
      :_destroy,
      :quantity,
      :consumed_food_time,
      food_attributes: Food.params,
    ]
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.consumed_food_time = User.current_user.time_now
    result
  end
  
  def quantity_with_fallback(default_quantity: 1)
    if !self.quantity.nil?
      self.quantity
    else
      default_quantity
    end
  end
end
