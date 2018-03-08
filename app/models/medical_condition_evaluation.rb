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
      medical_condition_evaluation_files_attributes: FilesController.multi_param_names,
      location_attributes: LocationsController.param_names
    ]
  end

  child_files

  child_property(name: :location)

  def file_folders_parent
    :medical_condition
  end
end
