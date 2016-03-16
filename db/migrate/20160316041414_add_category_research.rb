class AddCategoryResearch < ActiveRecord::Migration
  def change
    Category.create(name: "quests", link: "quests", position: 0, parent: Category.find_by_name("meaning"), icon: "FatCow_Icons16x16/magnifier.png")
  end
end
