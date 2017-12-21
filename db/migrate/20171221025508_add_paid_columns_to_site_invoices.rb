class AddPaidColumnsToSiteInvoices < ActiveRecord::Migration[5.1]
  def change
    add_column :site_invoices, :total_paid, :decimal, precision: 10, scale: 2
    add_column :site_invoices, :payment_notes, :text
  end
end
