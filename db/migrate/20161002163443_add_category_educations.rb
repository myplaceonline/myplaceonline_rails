class AddCategoryEducations < ActiveRecord::Migration
  def change
    Category.create(name: "educations", link: "educations", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/education.png")
  end
end
