class AddCategoryAgents < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "agents", link: "agents", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/account_menu.png")
  end
end
