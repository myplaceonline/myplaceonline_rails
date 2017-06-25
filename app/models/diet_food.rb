class DietFood < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

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
      food_attributes: Food.params
    ]
  end

end
