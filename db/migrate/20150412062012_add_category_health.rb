class AddCategoryHealth < ActiveRecord::Migration
  def change
    Category.create(name: "health", link: "health", position: 0, parent: Category.find_by_name("order"))
  end
end
