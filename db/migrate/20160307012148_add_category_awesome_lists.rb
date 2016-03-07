class AddCategoryAwesomeLists < ActiveRecord::Migration
  def change
    Category.create(name: "awesome_lists", link: "awesome_lists", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/emotion_grin.png")
  end
end
