class AddCategoryWebsites < ActiveRecord::Migration
  def change
    Category.create(name: "websites", link: "websites", position: 0, parent: Category.find_by_name("order"))
  end
end
