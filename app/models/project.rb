class Project < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :project_name, presence: true
  
  child_properties(name: :project_issues, sort: "position ASC")

  def display
    project_name
  end
  
  def set_positions(top_id: nil)
    ApplicationRecord.transaction do
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
    if !MyplaceonlineExecutionContext.offline?
      Rails.application.routes.url_helpers.send("new_project_project_issue_path", self)
    else
      nil
    end
  end
  
  def action_link_title
    I18n.t("myplaceonline.projects.project_issue_add")
  end
  
  def action_link_icon
    "plus"
  end

  def self.skip_check_attributes
    ["default_to_top"]
  end
end
