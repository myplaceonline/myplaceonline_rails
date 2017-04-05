class CreatePsychologicalEvaluations < ActiveRecord::Migration[5.0]
  def change
    create_table :psychological_evaluations do |t|
      t.string :psychological_evaluation_name
      t.date :evaluation_date
      t.references :evaluator, foreign_key: false
      t.decimal :score, precision: 10, scale: 2
      t.text :evaluation
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
    add_foreign_key :psychological_evaluations, :contacts, column: :evaluator_id
  end
end
