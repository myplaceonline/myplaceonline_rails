class AddCategoryDateLocations < ActiveRecord::Migration
  def change
    Category.create(name: "date_locations", link: "date_locations", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/heart.png")
  end
end
