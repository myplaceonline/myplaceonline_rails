class CreateJobAwards < ActiveRecord::Migration[5.0]
  def change
    create_table :job_awards do |t|
      t.date :job_award_date
      t.references :job, index: true
      t.decimal :job_award_amount, precision: 10, scale: 2
      t.string :job_award_description
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
