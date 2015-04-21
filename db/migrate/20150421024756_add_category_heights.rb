class AddCategoryHeights < ActiveRecord::Migration
  def change
    Category.create(name: "heights", link: "heights", position: 0, parent: Category.find_by_name("health"))
  end
end
