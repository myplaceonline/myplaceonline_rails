class Meadow < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :location, required: true)
  
  def display
    location.display
  end

  def self.skip_check_attributes
    ["visited"]
  end
end
