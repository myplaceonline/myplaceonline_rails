class TripFlight < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :trip

  belongs_to :flight
  accepts_nested_attributes_for :flight, reject_if: proc { |attributes| FlightsController.reject_if_blank(attributes) }
  allow_existing :flight
  
  def display
    flight.display
  end
end
