class AddCategoryIdeas < ActiveRecord::Migration
  def change
    Category.create(name: "ideas", link: "ideas", position: 0, parent: Category.find_by_name("order"))
  end
end
