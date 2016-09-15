class ExerciseRegimenExercise < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :exercise_regimen

  has_many :exercise_regimen_exercise_files, :dependent => :destroy
  accepts_nested_attributes_for :exercise_regimen_exercise_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :exercise_regimen_exercise_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(exercise_regimen_exercise_files, [I18n.t("myplaceonline.category.exercise_regimens"), exercise_regimen.display, display])
  end
  
  def display
    exercise_regimen_exercise_name
  end
end
