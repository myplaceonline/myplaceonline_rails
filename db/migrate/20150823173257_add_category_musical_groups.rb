class AddCategoryMusicalGroups < ActiveRecord::Migration
  def change
    Category.create(name: "musical_groups", link: "musical_groups", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/theater.png")
  end
end
