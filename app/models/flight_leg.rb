class FlightLeg < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :flight

  belongs_to :flight_company, class_name: Company
  accepts_nested_attributes_for :flight_company, reject_if: proc { |attributes| CompaniesController.reject_if_blank(attributes) }
  allow_existing :flight_company, Company

  belongs_to :depart_location, class_name: Location
  accepts_nested_attributes_for :depart_location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :depart_location, Location

  belongs_to :arrival_location, class_name: Location
  accepts_nested_attributes_for :arrival_location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :arrival_location, Location
end
