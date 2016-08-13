class CreateJobReviews < ActiveRecord::Migration
  def change
    create_table :job_reviews do |t|
      t.references :job, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.date :review_date
      t.string :company_score
      t.references :contact, index: true, foreign_key: true
      t.text :notes

      t.timestamps null: false
    end
  end
end
