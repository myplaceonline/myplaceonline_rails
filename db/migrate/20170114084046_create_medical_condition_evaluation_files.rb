class CreateMedicalConditionEvaluationFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :medical_condition_evaluation_files do |t|
      t.references :medical_condition_evaluation, foreign_key: true, index: false
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position

      t.timestamps
    end
    add_index :medical_condition_evaluation_files, :medical_condition_evaluation_id, name: "mcef_on_mcei"
  end
end
