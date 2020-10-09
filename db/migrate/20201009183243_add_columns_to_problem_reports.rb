class AddColumnsToProblemReports < ActiveRecord::Migration[5.2]
  def change
    add_column :problem_reports, :problem_started, :datetime
    add_column :problem_reports, :problem_resolved, :datetime
  end
end
