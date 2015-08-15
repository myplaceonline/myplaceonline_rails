class AddCategoryDoctors < ActiveRecord::Migration
  def change
    Category.create(name: "doctors", link: "doctors", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/user_medical.png")
  end
end
