class AddCategoryAllergies < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "allergies", link: "allergies", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/emotion_sweat.png")
  end
end
