class DrinkListDrink < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :drink, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  belongs_to :drink_list
  
  child_property(name: :drink, required: true)
  
  def display
    self.drink.display
  end
  
  def self.params
    [
      :id,
      :_destroy,
      drink_attributes: Drink.params
    ]
  end
end
