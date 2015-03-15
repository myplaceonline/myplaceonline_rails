class VehicleService < ActiveRecord::Base
  belongs_to :vehicle
  validates :short_description, presence: true
end
