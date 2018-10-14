class CreateCreditReportFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :credit_report_files do |t|
      t.references :credit_report, foreign_key: true
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position
      t.boolean :is_public

      t.timestamps
    end
  end
end
