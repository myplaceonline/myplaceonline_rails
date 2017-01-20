class Quest < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :quest_title, presence: true
  
  def display
    quest_title
  end

  child_files
end
