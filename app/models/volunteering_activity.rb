class VolunteeringActivity < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :volunteering_activity_name, presence: true
  
  def display
    volunteering_activity_name
  end
end
