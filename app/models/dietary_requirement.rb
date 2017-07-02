class DietaryRequirement < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  CONTEXT_PER_DAY = 0
  CONTEXT_PER_1000_CALORIES = 1

  CONTEXTS = [
    ["myplaceonline.dietary_requirements.contexts.per_day", CONTEXT_PER_DAY],
    ["myplaceonline.dietary_requirements.contexts.per_1000_calories", CONTEXT_PER_1000_CALORIES],
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
  
  def self.display_with_measurement(amount, type)
    "#{amount} #{Myp.get_select_name(type, Nutrient::MEASUREMENTS)}"
  end
end
