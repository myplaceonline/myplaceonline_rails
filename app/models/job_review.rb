class JobReview < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :job
  
  validates :review_date, presence: true

  belongs_to :contact
  accepts_nested_attributes_for :contact, reject_if: proc { |attributes| ContactsController.reject_if_blank(attributes) }
  allow_existing :contact

  has_many :job_review_files, :dependent => :destroy
  accepts_nested_attributes_for :job_review_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :job_review_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(job_review_files, [I18n.t("myplaceonline.jobs.reviews"), self.job.display])
  end
end
