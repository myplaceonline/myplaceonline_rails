class AddCategoryDrinkLists < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "drink_lists", link: "drink_lists", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/page_white_cup.png")
  end
end
