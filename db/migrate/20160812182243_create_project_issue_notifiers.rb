class CreateProjectIssueNotifiers < ActiveRecord::Migration
  def change
    create_table :project_issue_notifiers do |t|
      t.references :contact, index: true, foreign_key: true
      t.references :project_issue, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
