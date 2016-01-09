class AddCategoryOrders < ActiveRecord::Migration
  def change
    Category.create(name: "receipts", link: "receipts", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/receipt.png")
  end
end
