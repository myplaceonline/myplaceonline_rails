class FoodList < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :food_list_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :food_list_foods, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
    ]
  end

  validates :food_list_name, presence: true
  
  def display
    food_list_name
  end

  child_properties(name: :food_list_foods)
end
