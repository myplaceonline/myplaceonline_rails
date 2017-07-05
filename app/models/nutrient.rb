class Nutrient < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  MEASUREMENTS = [
    ["myplaceonline.nutrients.measurements.grams", 0],
    ["myplaceonline.nutrients.measurements.mg", 1],
    ["myplaceonline.nutrients.measurements.micrograms", 2],
    ["myplaceonline.nutrients.measurements.micrograms_rae", 3],
    ["myplaceonline.nutrients.measurements.liters", 4],
    ["myplaceonline.nutrients.measurements.ius", 5],
  ]
  
  def self.properties
    [
      { name: :nutrient_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :measurement_type, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
    ]
  end

  validates :nutrient_name, presence: true
  
  def display
    nutrient_name
  end
  
  def self.params
    [
      :id,
      :nutrient_name,
      :notes,
      :measurement_type,
    ]
  end
end
