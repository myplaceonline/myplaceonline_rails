class DietaryRequirement < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  MEASUREMENTS = [
    ["myplaceonline.dietary_requirements.measurements.grams", 0],
    ["myplaceonline.dietary_requirements.measurements.mg", 1],
    ["myplaceonline.dietary_requirements.measurements.micrograms", 2],
    ["myplaceonline.dietary_requirements.measurements.micrograms_rae", 3],
  ]

  def self.properties
    [
      { name: :dietary_requirement_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

  validates :dietary_requirement_name, presence: true
  
  belongs_to :dietary_requirements_collection
  
  def display
    dietary_requirement_name
  end

  def self.params
    [
      :id,
      :_destroy,
      :dietary_requirement_name,
      :dietary_requirement_amount,
      :dietary_requirement_type,
      :dietary_requirement_context,
      :notes,
    ]
  end
end
