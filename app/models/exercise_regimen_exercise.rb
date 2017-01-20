class ExerciseRegimenExercise < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :exercise_regimen

  child_files
  
  def file_folders_parent
    :exercise_regimen
  end

  def display
    exercise_regimen_exercise_name
  end
end
