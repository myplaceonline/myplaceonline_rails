class CreateProjectIssueFiles < ActiveRecord::Migration
  def change
    create_table :project_issue_files do |t|
      t.references :project_issue, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
