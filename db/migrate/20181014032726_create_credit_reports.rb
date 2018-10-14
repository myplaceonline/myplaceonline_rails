class CreateCreditReports < ActiveRecord::Migration[5.1]
  def change
    create_table :credit_reports do |t|
      t.date :credit_report_date
      t.integer :credit_reporting_agency
      t.string :credit_report_description
      t.boolean :annual_free_report
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.boolean :is_public
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
