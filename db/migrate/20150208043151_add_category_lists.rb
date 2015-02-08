class AddCategoryLists < ActiveRecord::Migration
  def change
    Category.create(name: "lists", link: "lists", position: 0, parent: Category.find_by_name("order"))
  end
end
