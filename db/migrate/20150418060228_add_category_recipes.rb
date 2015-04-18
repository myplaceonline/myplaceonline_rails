class AddCategoryRecipes < ActiveRecord::Migration
  def change
    Category.create(name: "recipes", link: "recipes", position: 0, parent: Category.find_by_name("joy"))
  end
end
