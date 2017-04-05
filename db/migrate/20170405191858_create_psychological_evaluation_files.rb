class CreatePsychologicalEvaluationFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :psychological_evaluation_files do |t|
      t.references :psychological_evaluation, foreign_key: true, index: false
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position

      t.timestamps
    end
    add_index :psychological_evaluation_files, :psychological_evaluation_id, name: "table_pef_on_pef_id"
  end
end
