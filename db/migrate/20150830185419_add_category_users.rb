class AddCategoryUsers < ActiveRecord::Migration
  def change
    Category.create(name: "users", link: "users", position: 0, parent: Category.find_by_name("order"), icon: "famfamfam/group.png")
  end
end
