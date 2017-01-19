class ExerciseRegimen < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :exercise_regimen_name, presence: true
  
  child_properties(name: :exercise_regimen_exercises, sort: "position ASC")

  def display
    exercise_regimen_name
  end
end
