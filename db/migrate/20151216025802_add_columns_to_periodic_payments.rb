class AddColumnsToPeriodicPayments < ActiveRecord::Migration
  def change
    add_reference :periodic_payments, :password, index: true, foreign_key: true
  end
end
