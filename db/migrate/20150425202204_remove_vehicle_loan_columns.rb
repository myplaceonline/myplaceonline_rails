class RemoveVehicleLoanColumns < ActiveRecord::Migration
  def change
    remove_column :vehicle_loans, :lender
    remove_column :vehicle_loans, :amount
    remove_column :vehicle_loans, :start
    remove_column :vehicle_loans, :paid_off
    remove_column :vehicle_loans, :monthly_payment
  end
end
