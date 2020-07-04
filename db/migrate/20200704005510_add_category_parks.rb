class AddCategoryParks < ActiveRecord::Migration[5.2]
  def change
    Category.create(name: "parks", link: "parks", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/tree.png")
  end
end
