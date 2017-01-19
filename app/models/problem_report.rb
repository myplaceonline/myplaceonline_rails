class ProblemReport < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :report_name, presence: true
  
  def display
    report_name
  end

  child_properties(name: :problem_report_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(problem_report_files, [I18n.t("myplaceonline.category.problem_reports"), display])
  end
end
