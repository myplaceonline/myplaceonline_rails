class CreateExerciseRegimen < ActiveRecord::Migration
  def change
    create_table :exercise_regimens do |t|
      t.string :exercise_regimen_name
      t.text :notes
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
