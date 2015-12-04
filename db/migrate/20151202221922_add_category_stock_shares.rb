class AddCategoryStockShares < ActiveRecord::Migration
  def change
    Category.create(name: "stocks", link: "stocks", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/finance.png")
  end
end
