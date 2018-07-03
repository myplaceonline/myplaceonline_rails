class SavedGame < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :game_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :game_time, type: ApplicationRecord::PROPERTY_TYPE_DATETIME },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :contact, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :saved_game_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :game_name, presence: true
  
  def display
    game_name
  end

  child_files

  child_property(name: :contact)
end
