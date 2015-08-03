class AddCategoryFavoriteThings < ActiveRecord::Migration
  def change
    Category.create(name: "favorite_products", link: "favorite_products", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/star.png")
  end
end
