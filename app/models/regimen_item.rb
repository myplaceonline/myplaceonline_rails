class RegimenItem < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :regimen_item_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

  belongs_to :regimen
  
  validates :regimen_item_name, presence: true
  
  def display
    regimen_item_name
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :regimen_item_name,
      :notes,
      :position,
    ]
  end
end
