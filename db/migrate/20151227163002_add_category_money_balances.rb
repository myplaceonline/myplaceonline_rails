class AddCategoryMoneyBalances < ActiveRecord::Migration
  def change
    Category.create(name: "money_balances", link: "money_balances", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/blackboard_sum.png")
  end
end
