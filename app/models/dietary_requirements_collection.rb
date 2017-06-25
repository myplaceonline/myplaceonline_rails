class DietaryRequirementsCollection < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :dietary_requirements_collection_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :dietary_requirements_collection_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :dietary_requirements_collection_name, presence: true
  
  def display
    dietary_requirements_collection_name
  end

  child_files
  
  child_properties(name: :dietary_requirements, sort: "dietary_requirement_name ASC")

end
