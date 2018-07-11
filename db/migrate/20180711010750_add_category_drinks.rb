class AddCategoryDrinks < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "drinks", link: "drinks", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/glass_of_wine_empty.png")
  end
end
