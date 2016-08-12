class ProjectIssue < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  attr_accessor :top

  validates :issue_name, presence: true
  
  belongs_to :project

  has_many :project_issue_notifiers, :dependent => :destroy
  accepts_nested_attributes_for :project_issue_notifiers, allow_destroy: true, reject_if: :all_blank

  def display
    issue_name
  end
  
  def final_search_result
    project
  end

  after_commit :on_after_create, on: [:create]
  
  def on_after_create
    if position.nil?
      if self.top == "1"
        self.project.set_positions(top_id: self.id)
      else
        self.project.set_positions
      end
    end
  end
end
