class UserCapability < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  CAPABILITIES = [
    ["myplaceonline.user_capabilities.capability_screen_scraper", 0],
  ]

  def self.properties
    [
      { name: :capability, type: ApplicationRecord::PROPERTY_TYPE_SELECT },
    ]
  end

  validates :capability, presence: true
  
  def display
    Myp.get_select_name(self.capability, UserCapability::CAPABILITIES)
  end
end
