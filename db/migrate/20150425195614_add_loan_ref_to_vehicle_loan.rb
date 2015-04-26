class AddLoanRefToVehicleLoan < ActiveRecord::Migration
  def change
    add_reference :vehicle_loans, :loan
  end
end
