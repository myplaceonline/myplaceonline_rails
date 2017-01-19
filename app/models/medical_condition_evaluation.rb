class MedicalConditionEvaluation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :medical_condition
  
  validates :evaluation_datetime, presence: true
  
  def display
    Myp.appendstrwrap(medical_condition.display, Myp.display_datetime_short(self.evaluation_datetime, User.current_user))
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :evaluation_datetime,
      :notes,
      medical_condition_evaluation_files_attributes: FilesController.multi_param_names
    ]
  end

  child_properties(name: :medical_condition_evaluation_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]

  def update_file_folders
    put_files_in_folder(medical_condition_evaluation_files, [I18n.t("myplaceonline.category.medical_condition_evaluations"), medical_condition.display, display])
  end
end
