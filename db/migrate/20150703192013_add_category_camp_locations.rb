class AddCategoryCampLocations < ActiveRecord::Migration
  def change
    Category.create(name: "camp_locations", link: "camp_locations", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/tree.png")
  end
end
