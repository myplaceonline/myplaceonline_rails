class AddCategorySkinTreatments < ActiveRecord::Migration
  def change
    Category.create(name: "skin_treatments", link: "skin_treatments", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/user_nude.png")
  end
end
