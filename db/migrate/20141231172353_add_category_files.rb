class AddCategoryFiles < ActiveRecord::Migration
  def change
    Category.create(name: "files", link: "files", position: 0, parent: Category.find_by_name("order"))
  end
end
