class DrinkList < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :drink_list_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :drink_list_drinks, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
    ]
  end

  validates :drink_list_name, presence: true
  
  def display
    drink_list_name
  end

  child_properties(name: :drink_list_drinks)
end
