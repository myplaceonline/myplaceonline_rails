class UserCapability < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  
  CAPABILITY_SCREEN_SCRAPER = 0

  CAPABILITIES = [
    ["myplaceonline.user_capabilities.capability_screen_scraper", CAPABILITY_SCREEN_SCRAPER],
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
  
  def self.has_capability?(identity:, capability:)
    !UserCapability.where(identity: identity, capability: capability).take.nil?
  end
end
