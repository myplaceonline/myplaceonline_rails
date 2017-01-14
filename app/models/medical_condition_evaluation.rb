class MedicalConditionEvaluation < ActiveRecord::Base
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

  has_many :medical_condition_evaluation_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :medical_condition_evaluation_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :medical_condition_evaluation_files, [{:name => :identity_file}]

  before_validation :update_file_folders

  def update_file_folders
    put_files_in_folder(medical_condition_evaluation_files, [I18n.t("myplaceonline.category.medical_condition_evaluations"), display])
  end
end
