class AddFiltertextToPeriodicPayments < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("periodic_payments", "recurring")
  end
end
