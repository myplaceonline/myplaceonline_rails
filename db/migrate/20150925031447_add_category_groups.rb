class AddCategoryGroups < ActiveRecord::Migration
  def change
    Category.create(name: "groups", link: "groups", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/group.png")
  end
end
