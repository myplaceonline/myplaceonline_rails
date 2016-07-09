class ProjectIssue < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :issue_name, presence: true
  
  belongs_to :project

  def display
    issue_name
  end
end
