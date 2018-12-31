class AddColumnPercentileToTestScores < ActiveRecord::Migration[5.1]
  def change
    add_column :test_scores, :percentile, :integer
  end
end
