class AddCategoryFiltertextExerciseRegimens < ActiveRecord::Migration[5.0]
  def change
    Myp.migration_add_filtertext("exercise_regimens", "workouts")
  end
end
