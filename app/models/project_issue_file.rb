class ProjectIssueFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :project_issue

  validates :identity_file, presence: true

  child_property(name: :identity_file)
end
