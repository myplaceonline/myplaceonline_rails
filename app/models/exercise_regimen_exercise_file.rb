class ExerciseRegimenExerciseFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :exercise_regimen_exercise

  child_property(name: :identity_file, required: true)
end
