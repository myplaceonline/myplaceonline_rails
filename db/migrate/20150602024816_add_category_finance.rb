class AddCategoryFinance < ActiveRecord::Migration
  def change
    Category.create(name: "finance", link: "finance", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/coins.png")
  end
end
