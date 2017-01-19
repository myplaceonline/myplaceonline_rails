class JobReviewFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :job_review

  validates :identity_file, presence: true

  child_property(name: :identity_file)
end
