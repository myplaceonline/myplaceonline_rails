class AddCategoryHobbies < ActiveRecord::Migration
  def change
    Category.create(name: "hobbies", link: "hobbies", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/paper_airplane.png")
  end
end
