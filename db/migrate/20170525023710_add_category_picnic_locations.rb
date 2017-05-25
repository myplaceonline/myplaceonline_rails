class AddCategoryPicnicLocations < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "picnic_locations", link: "picnic_locations", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/grass.png")
  end
end
