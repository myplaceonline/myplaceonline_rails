class VehicleLoan < ActiveRecord::Base
  belongs_to :vehicle
  validates :lender, presence: true
end
