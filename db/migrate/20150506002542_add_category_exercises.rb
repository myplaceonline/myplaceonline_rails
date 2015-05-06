class AddCategoryExercises < ActiveRecord::Migration
  def change
    Category.create(name: "exercises", link: "exercises", position: 0, parent: Category.find_by_name("health"))
  end
end
