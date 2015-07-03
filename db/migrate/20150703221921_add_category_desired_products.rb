class AddCategoryDesiredProducts < ActiveRecord::Migration
  def change
    Category.create(name: "desired_products", link: "desired_products", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/cart.png")
  end
end
