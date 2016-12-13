class Project < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :project_name, presence: true
  
  has_many :project_issues, -> { order('position ASC') }, :dependent => :destroy
  accepts_nested_attributes_for :project_issues, allow_destroy: true, reject_if: :all_blank

  def display
    project_name
  end
  
  def set_positions(top_id: nil)
    ActiveRecord::Base.transaction do
      i = top_id.nil? ? 1 : 2
      project_issues.each do |issue|
        if !top_id.nil? && issue.id == top_id
          issue.position = 1
          issue.save!
        else
          issue.position = i
          i = i + 1
          issue.save!
        end
      end
    end
  end
  
  def action_link
    Rails.application.routes.url_helpers.send("new_project_project_issue_path", self)
  end
  
  def action_link_title
    I18n.t("myplaceonline.projects.project_issue_add")
  end
  
  def action_link_icon
    "plus"
  end
end
