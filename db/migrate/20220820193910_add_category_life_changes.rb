class AddCategoryLifeChanges < ActiveRecord::Migration[6.1]
  def change
    Category.create(name: "life_changes", link: "life_changes", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/account_menu.png")
  end
end
