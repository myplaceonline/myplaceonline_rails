class AddCategoryFavoriteLocations < ActiveRecord::Migration
  def change
    Category.create(name: "favorite_locations", link: "favorite_locations", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/earth_night.png")
  end
end
