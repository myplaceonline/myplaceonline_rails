class GasStation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :location, required: true)

  def display
    location.display
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.gas = true
    result
  end

  def self.skip_check_attributes
    ["gas", "diesel", "propane_fillup", "propane_replacement"]
  end
end
