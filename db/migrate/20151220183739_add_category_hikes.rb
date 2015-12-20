class AddCategoryHikes < ActiveRecord::Migration
  def change
    Category.create(name: "treks", link: "treks", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/tree.png")
  end
end
