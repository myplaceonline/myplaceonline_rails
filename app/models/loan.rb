class Loan < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :lender, presence: true

  def self.params
    [
      :id,
      :lender,
      :amount,
      :start,
      :paid_off,
      :monthly_payment,
    ]
  end

  def final_search_result
    result = nil
    result = VehicleLoan.where(loan_id: self.id).take
    if !result.nil?
      result = result.vehicle
    else
      result = RecreationalVehicleLoan.where(loan_id: self.id).take
      if !result.nil?
        result = result.recreational_vehicle
      end
    end
    result
  end
end
