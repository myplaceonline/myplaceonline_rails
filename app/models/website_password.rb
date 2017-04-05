class WebsitePassword < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :password, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end
  
  belongs_to :website

  child_property(name: :password)

  validates :password, presence: true
end
