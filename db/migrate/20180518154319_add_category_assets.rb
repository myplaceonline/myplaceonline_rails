class AddCategoryAssets < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "financial_assets", link: "financial_assets", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/moneybox.png")
  end
end
