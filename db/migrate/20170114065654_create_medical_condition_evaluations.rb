class CreateMedicalConditionEvaluations < ActiveRecord::Migration[5.0]
  def change
    create_table :medical_condition_evaluations do |t|
      t.references :medical_condition, foreign_key: true
      t.text :notes
      t.datetime :evaluation_datetime
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
