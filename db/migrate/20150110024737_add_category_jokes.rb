class AddCategoryJokes < ActiveRecord::Migration
  def change
    Category.create(name: "jokes", link: "jokes", position: 0, parent: Category.find_by_name("joy"))
  end
end
