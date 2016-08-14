class ProblemReport < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :report_name, presence: true
  
  def display
    report_name
  end

  has_many :problem_report_files, :dependent => :destroy
  accepts_nested_attributes_for :problem_report_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :problem_report_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(problem_report_files, [I18n.t("myplaceonline.category.problem_reports"), display])
  end
end
