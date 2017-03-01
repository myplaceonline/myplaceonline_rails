class AddCategoryFiltertextTestScores < ActiveRecord::Migration[5.0]
  def change
    Myp.migration_add_filtertext("test_scores", "SAT")
  end
end
