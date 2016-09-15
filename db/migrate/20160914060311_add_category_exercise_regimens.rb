class AddCategoryExerciseRegimens < ActiveRecord::Migration
  def change
    Category.create(name: "exercise_regimens", link: "exercise_regimens", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/walk.png")
  end
end
