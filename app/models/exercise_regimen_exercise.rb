class ExerciseRegimenExercise < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :exercise_regimen

  child_properties(name: :exercise_regimen_exercise_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(exercise_regimen_exercise_files, [I18n.t("myplaceonline.category.exercise_regimens"), exercise_regimen.display, display])
  end
  
  def display
    exercise_regimen_exercise_name
  end
end
