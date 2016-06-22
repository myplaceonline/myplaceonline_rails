class AddCategoryProjects < ActiveRecord::Migration
  def change
    Category.create(name: "projects", link: "projects", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/hammer.png")
  end
end
