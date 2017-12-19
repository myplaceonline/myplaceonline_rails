class AddColumnDescriptionToSiteInvoices < ActiveRecord::Migration[5.1]
  def change
    add_column :site_invoices, :invoice_description, :string
  end
end
