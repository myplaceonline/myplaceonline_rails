class ExerciseRegimenExercise < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :exercise_regimen
  
  
end
