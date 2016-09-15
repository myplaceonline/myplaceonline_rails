class ExerciseRegimen < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :exercise_regimen_name, presence: true
  
  has_many :exercise_regimen_exercises, -> { order('position ASC') }, :dependent => :destroy
  accepts_nested_attributes_for :exercise_regimen_exercises, allow_destroy: true, reject_if: :all_blank

  def display
    exercise_regimen_name
  end
end
