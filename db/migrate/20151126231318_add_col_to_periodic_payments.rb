class AddColToPeriodicPayments < ActiveRecord::Migration
  def change
    add_column :periodic_payments, :suppress_reminder, :boolean
  end
end
