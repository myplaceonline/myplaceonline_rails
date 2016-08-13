class CreateJobReviewFiles < ActiveRecord::Migration
  def change
    create_table :job_review_files do |t|
      t.references :job_review, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
