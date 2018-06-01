class AddCategoryBoondockings < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "boondockings", link: "boondockings", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/tree_red.png")
  end
end
