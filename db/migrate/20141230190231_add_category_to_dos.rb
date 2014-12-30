class AddCategoryToDos < ActiveRecord::Migration
  def change
    Category.create(name: "to_dos", link: "to_dos", position: 0, parent: Category.find_by_name("order"))
  end
end
