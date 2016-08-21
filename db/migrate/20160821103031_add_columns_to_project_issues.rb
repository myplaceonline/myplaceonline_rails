class AddColumnsToProjectIssues < ActiveRecord::Migration
  def change
    add_column :project_issues, :archived, :datetime
  end
end
