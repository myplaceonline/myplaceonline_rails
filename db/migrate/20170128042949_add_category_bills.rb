class AddCategoryBills < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "bills", link: "bills", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/document_info.png", additional_filtertext: "invoices")
  end
end
