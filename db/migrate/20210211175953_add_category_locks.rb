class AddCategoryLocks < ActiveRecord::Migration[5.2]
  def change
    Category.create(name: "locks", link: "locks", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/lock.png")
  end
end
