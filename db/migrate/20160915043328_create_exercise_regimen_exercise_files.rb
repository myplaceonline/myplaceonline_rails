class CreateExerciseRegimenExerciseFiles < ActiveRecord::Migration
  def change
    create_table :exercise_regimen_exercise_files do |t|
      t.references :exercise_regimen_exercise, index: false, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
    add_index :exercise_regimen_exercise_files, :exercise_regimen_exercise_id, name: "eref_on_erei"
  end
end
