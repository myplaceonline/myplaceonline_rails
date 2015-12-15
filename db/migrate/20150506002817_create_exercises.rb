class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.datetime :exercise_start
      t.datetime :exercise_end
      t.string :exercise_activity
      t.text :notes
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
