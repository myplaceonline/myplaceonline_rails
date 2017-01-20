class Vaccine < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :vaccine_name, presence: true
  
  def display
    vaccine_name
  end

  child_files
end
