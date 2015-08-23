class AddPeriodicPaymentsToSubscriptions < ActiveRecord::Migration
  def change
    add_reference :subscriptions, :periodic_payment, index: true
  end
end
