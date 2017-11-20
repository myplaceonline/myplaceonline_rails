class CreateReputationReportFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :reputation_report_files do |t|
      t.references :reputation_report, foreign_key: true
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
