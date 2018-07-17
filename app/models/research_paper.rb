class ResearchPaper < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :document, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  def display
    document.display
  end

  child_property(name: :document, required: true)
end
