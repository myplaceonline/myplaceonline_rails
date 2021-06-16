class AddCategorySteakHouses < ActiveRecord::Migration[6.1]
  def change
    Category.create(name: "steakhouses", link: "steakhouses", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/steak_fish.png")
  end
end
