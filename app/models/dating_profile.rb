class DatingProfile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :dating_profile_name, presence: true
  
  def display
    dating_profile_name
  end

  child_files
end
