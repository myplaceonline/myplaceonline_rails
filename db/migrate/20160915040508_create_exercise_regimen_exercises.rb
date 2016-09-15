class CreateExerciseRegimenExercises < ActiveRecord::Migration
  def change
    create_table :exercise_regimen_exercises do |t|
      t.string :exercise_regimen_exercise_name
      t.text :notes
      t.integer :position
      t.references :exercise_regimen, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
