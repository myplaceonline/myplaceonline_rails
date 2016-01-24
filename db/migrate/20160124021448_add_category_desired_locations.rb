class AddCategoryDesiredLocations < ActiveRecord::Migration
  def change
    Category.create(name: "desired_locations", link: "desired_locations", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/map_magnify.png")
  end
end
