class AddCategoryNutrients < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "nutrients", link: "nutrients", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/node.png")
  end
end
