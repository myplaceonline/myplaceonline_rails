# https://you.23andme.com/tools/data/download/
# Click "Submit Request" at the bottom
class DnaAnalysis < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :import, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  def display
    import.display
  end

  child_property(name: :import, required: true, destroy_dependent: true)
end
