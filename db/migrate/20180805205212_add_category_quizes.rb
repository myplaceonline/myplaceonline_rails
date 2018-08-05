class AddCategoryQuizes < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "quizzes", link: "quizzes", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/question.png")
  end
end
