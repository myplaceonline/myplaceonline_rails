class Injury < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ModelHelpersConcern
  
  validates :injury_name, presence: true
  
  def display
    injury_name
  end
  
  child_property(name: :location)
  
  child_files
end
