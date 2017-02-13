class License < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :license_name, presence: true
  
  def display
    license_name
  end

  child_files
end
