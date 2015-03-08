class CreateVehicleLoans < ActiveRecord::Migration
  def change
    create_table :vehicle_loans do |t|
      t.string :lender
      t.references :vehicle, index: true
      t.decimal :amount, precision: 10, scale: 2
      t.date :start
      t.date :paid_off
      t.decimal :monthly_payment, precision: 10, scale: 2

      t.timestamps
    end
  end
end
