class CreateCreditScores < ActiveRecord::Migration
  def change
    create_table :credit_scores do |t|
      t.date :score_date
      t.integer :score
      t.string :source
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
