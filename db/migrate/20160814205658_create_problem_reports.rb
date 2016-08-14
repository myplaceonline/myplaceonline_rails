class CreateProblemReports < ActiveRecord::Migration
  def change
    create_table :problem_reports do |t|
      t.string :report_name
      t.text :notes
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
