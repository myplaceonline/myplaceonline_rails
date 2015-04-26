class ChangeVehicleLoans < ActiveRecord::Migration
  def change
    add_reference :vehicle_loans, :identity, index: true
    VehicleLoan.all.each{|vl|

      v = vl.vehicle

      l = Loan.new
      l.lender = vl.lender
      l.amount = vl.amount
      l.start = vl.start
      l.paid_off = vl.paid_off
      l.monthly_payment = vl.monthly_payment
      l.identity = v.identity
      l.save!

      vl.identity = v.identity
      vl.loan_id = l.id
      vl.save!
    }
  end
end
