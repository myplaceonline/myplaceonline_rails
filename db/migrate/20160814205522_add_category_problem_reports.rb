class AddCategoryProblemReports < ActiveRecord::Migration
  def change
    Category.create(name: "problem_reports", link: "problem_reports", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/exclamation.png")
  end
end
