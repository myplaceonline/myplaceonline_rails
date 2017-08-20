class AddCategoryBoycotts < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "boycotts", link: "boycotts", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/cart_error.png", experimental: true)
  end
end
