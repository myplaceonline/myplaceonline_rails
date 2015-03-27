class AddCategoryQuestions < ActiveRecord::Migration
  def change
    Category.create(name: "questions", link: "questions", position: 0, parent: Category.find_by_name("meaning"))
  end
end
