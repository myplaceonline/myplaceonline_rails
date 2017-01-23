class AddColumnsToTestScores < ActiveRecord::Migration[5.0]
  def change
    add_column :test_scores, :test_score, :decimal, precision: 10, scale: 2
  end
end
