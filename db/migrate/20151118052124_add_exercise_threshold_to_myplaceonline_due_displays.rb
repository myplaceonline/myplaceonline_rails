class AddExerciseThresholdToMyplaceonlineDueDisplays < ActiveRecord::Migration
  def change
    add_column :myplaceonline_due_displays, :exercise_threshold, :integer
  end
end
