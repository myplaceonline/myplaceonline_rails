class CreateReputationReportMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :reputation_report_messages do |t|
      t.references :reputation_report, foreign_key: true
      t.references :message, foreign_key: true
      t.references :identity, foreign_key: true
      t.datetime :archived
      t.boolean :is_public

      t.timestamps
    end
  end
end
