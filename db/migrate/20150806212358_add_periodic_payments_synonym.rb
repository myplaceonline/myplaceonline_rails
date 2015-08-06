class AddPeriodicPaymentsSynonym < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("subscriptions", "memberships")
  end
end
