class FlightLeg < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :flight

  child_property(name: :flight_company, model: Company)

  child_property(name: :depart_location, model: Location)

  child_property(name: :arrival_location, model: Location)
end
