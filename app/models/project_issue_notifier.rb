class ProjectIssueNotifier < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :project_issue

  child_property(name: :contact, required: true)
end
