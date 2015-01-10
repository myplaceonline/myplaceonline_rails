class AddCategoryPromises < ActiveRecord::Migration
  def change
    Category.create(name: "promises", link: "promises", position: 0, parent: Category.find_by_name("order"))
  end
end
