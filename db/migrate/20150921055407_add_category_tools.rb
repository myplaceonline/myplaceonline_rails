class AddCategoryTools < ActiveRecord::Migration
  def change
    Category.create(name: "tools", link: "tools", position: 0, parent: Category.find_by_name("order"), icon: "famfamfam/wrench.png")
  end
end
