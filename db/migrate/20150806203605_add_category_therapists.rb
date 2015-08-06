class AddCategoryTherapists < ActiveRecord::Migration
  def change
    Category.create(name: "therapists", link: "therapists", position: 0, parent: Category.find_by_name("meaning"), icon: "FatCow_Icons16x16/account_functions.png")
  end
end
