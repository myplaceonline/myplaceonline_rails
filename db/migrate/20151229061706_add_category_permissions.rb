class AddCategoryPermissions < ActiveRecord::Migration
  def change
    Category.create(name: "permissions", link: "permissions", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/lock.png")
  end
end
