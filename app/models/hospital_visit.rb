class HospitalVisit < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ModelHelpersConcern
  
  validates :hospital_visit_purpose, presence: true
  
  def display
    hospital_visit_purpose
  end
  
  child_property(name: :hospital, model: Location)
  
  child_files

  def self.skip_check_attributes
    ["emergency_room"]
  end
end
