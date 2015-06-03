class AddCategoryPeriodicPayments < ActiveRecord::Migration
  def change
    Category.create(name: "periodic_payments", link: "periodic_payments", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/table_money.png")
  end
end
