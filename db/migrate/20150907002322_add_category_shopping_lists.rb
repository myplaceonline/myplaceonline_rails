class AddCategoryShoppingLists < ActiveRecord::Migration
  def change
    Category.create(name: "shopping_lists", link: "shopping_lists", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/cart_put.png")
  end
end
