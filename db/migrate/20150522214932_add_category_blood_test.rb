class AddCategoryBloodTest < ActiveRecord::Migration
  def change
    Category.create(name: "blood_tests", link: "blood_tests", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/injection_red.png")
  end
end
