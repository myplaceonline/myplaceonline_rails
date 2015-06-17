class AddCategoryComputers < ActiveRecord::Migration
  def change
    Category.create(name: "computers", link: "computers", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/laptop.png")
  end
end
