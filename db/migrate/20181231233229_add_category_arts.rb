class AddCategoryArts < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "arts", link: "arts", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/palette.png")
  end
end
