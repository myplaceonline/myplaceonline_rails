class CreateProblemReportFiles < ActiveRecord::Migration
  def change
    create_table :problem_report_files do |t|
      t.references :problem_report, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
