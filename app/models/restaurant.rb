class Restaurant < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :location, presence: true

  child_property(name: :location)
  
  def display
    location.display
  end

  child_pictures

  def self.skip_check_attributes
    ["visited"]
  end
end
