class ProjectIssue < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :issue_name, presence: true
  
  belongs_to :project

  def display
    issue_name
  end
  
  def final_search_result
    project
  end

  after_commit :on_after_create, on: [:create]
  
  def on_after_create
    if position.nil?
      self.project.set_positions
    end
  end
end
