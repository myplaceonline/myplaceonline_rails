class ExerciseRegimen < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :exercise_regimen_name, presence: true
  
  def display
    exercise_regimen_name
  end
end
