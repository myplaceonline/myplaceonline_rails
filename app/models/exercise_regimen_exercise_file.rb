class ExerciseRegimenExerciseFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_file(parent: :exercise_regimen_exercise)
end
