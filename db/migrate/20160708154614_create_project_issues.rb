class CreateProjectIssues < ActiveRecord::Migration
  def change
    create_table :project_issues do |t|
      t.references :project, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.integer :position
      t.string :issue_name
      t.text :notes

      t.timestamps null: false
    end
  end
end
