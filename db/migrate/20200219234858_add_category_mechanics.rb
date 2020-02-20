class AddCategoryMechanics < ActiveRecord::Migration[5.2]
  def change
    Category.create(name: "mechanics", link: "mechanics", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/construction.png")
  end
end
