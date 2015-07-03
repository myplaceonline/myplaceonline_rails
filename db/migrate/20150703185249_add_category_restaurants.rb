class AddCategoryRestaurants < ActiveRecord::Migration
  def change
    Category.create(name: "restaurants", link: "restaurants", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/cutleries.png")
  end
end
