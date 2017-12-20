class AddColumnFirstChargeToSiteInvoices < ActiveRecord::Migration[5.1]
  def change
    add_column :site_invoices, :first_charge, :decimal, precision: 10, scale: 2
  end
end
