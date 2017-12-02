class Meadow < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :location)
  
  child_property(name: :trek, required: true)
  
  def display
    trek.display
  end

  def self.skip_check_attributes
    ["visited"]
  end
end
