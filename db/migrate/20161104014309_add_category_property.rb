class AddCategoryProperty < ActiveRecord::Migration
  def change
    Category.create(name: "items", link: "items", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/rubber_duck.png")
  end
end
