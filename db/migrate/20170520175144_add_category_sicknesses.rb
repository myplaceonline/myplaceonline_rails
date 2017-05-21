class AddCategorySicknesses < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "sicknesses", link: "sicknesses", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/emotion_sick.png")
  end
end
