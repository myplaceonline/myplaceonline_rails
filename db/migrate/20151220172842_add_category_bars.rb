class AddCategoryBars < ActiveRecord::Migration
  def change
    Category.create(name: "bars", link: "bars", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/glass_of_wine_full.png")
  end
end
