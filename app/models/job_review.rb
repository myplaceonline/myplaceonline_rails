class JobReview < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :job
  
  validates :review_date, presence: true

  child_property(name: :contact)

  child_properties(name: :job_review_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(job_review_files, [I18n.t("myplaceonline.jobs.reviews"), self.job.display])
  end

  def final_search_result
    job
  end
end
