class VolunteeringActivity < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :volunteering_activity_name, presence: true
  
  def display
    volunteering_activity_name
  end
end
