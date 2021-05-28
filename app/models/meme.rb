class Meme < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :meme_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :test_object_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :meme_name, presence: true
  
  def display
    meme_name
  end

  child_files
end
