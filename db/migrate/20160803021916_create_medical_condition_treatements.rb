class CreateMedicalConditionTreatements < ActiveRecord::Migration
  def change
    create_table :medical_condition_treatments do |t|
      t.references :identity, index: true, foreign_key: true
      t.references :medical_condition, index: true, foreign_key: true
      t.date :treatment_date
      t.text :notes
      t.string :treatment_description
      t.references :doctor, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
