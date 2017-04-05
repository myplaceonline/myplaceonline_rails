class AddCategoryPsychologicalEvaluations < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "psychological_evaluations", link: "psychological_evaluations", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/emotion_detective.png")
  end
end
