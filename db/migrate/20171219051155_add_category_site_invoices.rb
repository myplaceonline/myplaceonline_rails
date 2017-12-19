class AddCategorySiteInvoices < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "site_invoices", link: "site_invoices", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/receipt_invoice.png", internal: true)
  end
end
