class CreateReputationReportMessageFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :reputation_report_message_files do |t|
      t.references :reputation_report_message, foreign_key: true, index: false
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position

      t.timestamps
    end
    add_index :reputation_report_message_files, :reputation_report_message_id, name: "rrmf_on_rrmi"
  end
end
