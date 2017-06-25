class AddCategoryDiets < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "diets", link: "diets", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/omelet.png")
  end
end
