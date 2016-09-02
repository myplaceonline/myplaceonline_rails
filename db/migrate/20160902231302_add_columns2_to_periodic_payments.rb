class AddColumns2ToPeriodicPayments < ActiveRecord::Migration
  def change
    add_column :periodic_payments, :archived, :datetime
  end
end
