class AddCategoryDessertLocations < ActiveRecord::Migration
  def change
    Category.create(name: "dessert_locations", link: "dessert_locations", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/piece_of_cake.png")
  end
end
