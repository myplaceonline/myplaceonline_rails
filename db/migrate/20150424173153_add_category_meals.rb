class AddCategoryMeals < ActiveRecord::Migration
  def change
    Category.create(name: "meals", link: "meals", position: 0, parent: Category.find_by_name("health"))
  end
end
