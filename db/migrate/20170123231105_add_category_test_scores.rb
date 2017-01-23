class AddCategoryTestScores < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "test_scores", link: "test_scores", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/application_edit.png")
  end
end
