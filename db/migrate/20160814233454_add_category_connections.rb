class AddCategoryConnections < ActiveRecord::Migration
  def change
    Category.create(name: "connections", link: "connections", position: 0, parent: Category.find_by_name("meaning"), icon: "FatCow_Icons16x16/users_men_women.png")
  end
end
