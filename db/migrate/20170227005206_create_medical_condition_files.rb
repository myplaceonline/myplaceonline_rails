class CreateMedicalConditionFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :medical_condition_files do |t|
      t.references :medical_condition, foreign_key: true
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
