class Translation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :translation_input, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :translation_output, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :input_language, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :output_language, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :source, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :website, type: ApplicationRecord::PROPERTY_TYPE_STRING },
    ]
  end

  validates :translation_input, presence: true
  validates :translation_output, presence: true
  
  def display
    translation_input
  end
end
