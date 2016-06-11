class AddCategoryMeadows < ActiveRecord::Migration
  def change
    Category.create(name: "meadows", link: "meadows", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/butterfly.png")
  end
end
