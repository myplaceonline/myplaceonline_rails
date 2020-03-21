class FoodListFood < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :food, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  belongs_to :food_list
  
  child_property(name: :food, required: true)
  
  def display
    self.food.display
  end
  
  def self.params
    [
      :id,
      :_destroy,
      food_attributes: Food.params
    ]
  end
  
  def parent_context
    return self.food_list
  end
end
