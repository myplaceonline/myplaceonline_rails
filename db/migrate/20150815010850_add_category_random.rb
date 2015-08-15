class AddCategoryRandom < ActiveRecord::Migration
  def change
    Category.create(name: "random", link: "random", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/dice.png")
  end
end
