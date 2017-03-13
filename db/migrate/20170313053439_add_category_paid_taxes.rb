class AddCategoryPaidTaxes < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "paid_taxes", link: "paid_taxes", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/money.png")
  end
end
