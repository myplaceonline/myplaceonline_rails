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
      :test_object_instance_name,
      food_attributes: Food.params
    ]
  end
end
