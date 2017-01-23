class CreateTestScores < ActiveRecord::Migration[5.0]
  def change
    create_table :test_scores do |t|
      t.string :test_score_name
      t.date :test_score_date
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
