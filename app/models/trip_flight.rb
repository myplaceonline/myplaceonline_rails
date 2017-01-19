class TripFlight < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :trip

  child_property(name: :flight)
  
  def display
    flight.display
  end
end
