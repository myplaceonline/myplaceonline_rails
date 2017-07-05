class Nutrient < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  
  MEASUREMENT_GRAMS = 0
  MEASUREMENT_MILLI_GRAMS = 1
  MEASUREMENT_MICRO_GRAMS = 2
  MEASUREMENT_MICRO_GRAMS_RAE = 3
  MEASUREMENT_LITERS = 4
  MEASUREMENT_IUS = 5

  MEASUREMENTS = [
    ["myplaceonline.nutrients.measurements.grams", MEASUREMENT_GRAMS],
    ["myplaceonline.nutrients.measurements.mg", MEASUREMENT_MILLI_GRAMS],
    ["myplaceonline.nutrients.measurements.micrograms", MEASUREMENT_MICRO_GRAMS],
    ["myplaceonline.nutrients.measurements.micrograms_rae", MEASUREMENT_MICRO_GRAMS_RAE],
    ["myplaceonline.nutrients.measurements.liters", MEASUREMENT_LITERS],
    ["myplaceonline.nutrients.measurements.ius", MEASUREMENT_IUS],
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
