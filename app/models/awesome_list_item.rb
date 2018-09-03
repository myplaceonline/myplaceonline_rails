class AwesomeListItem < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :item_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
    ]
  end

  belongs_to :awesome_list
  
  validates :item_name, presence: true
  
  def display
    item_name
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :item_name,
    ]
  end
end
