class ProjectIssue < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ModelHelpersConcern

  attr_accessor :top

  validates :issue_name, presence: true
  
  belongs_to :project

  child_properties(name: :project_issue_notifiers)

  def display
    issue_name
  end
  
  def final_search_result
    project
  end

  after_commit :on_after_create, on: [:create]
  
  def on_after_create
    if MyplaceonlineExecutionContext.handle_updates?
      if position.nil?
        if self.top == "1"
          self.project.set_positions(top_id: self.id)
        else
          self.project.set_positions
        end
      end
    end
  end

  def complete_successfully
    if self.issue_name.length < 25
      subject = I18n.t("myplaceonline.project_issues.issue_completed_subject_full", project_name: self.project.display, issue_name: self.display)
    else
      subject = I18n.t("myplaceonline.project_issues.issue_completed_subject_short", project_name: self.project.display)
    end
    body_markdown = I18n.t("myplaceonline.project_issues.issue_completed_body", project_name: self.project.display, issue_name: self.display)
    if !self.notes.blank?
      body_markdown += I18n.t("myplaceonline.project_issues.issue_completed_body_details", details: self.notes)
    end
    project_issue_notifiers.each do |notifier|
      notifier.contact.send_email_with_conversation(self.project.display, subject, body_markdown)
    end
    self.is_archived = true
    self.save!
  end

  child_properties(name: :project_issue_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(project_issue_files, [I18n.t("myplaceonline.category.projects"), project.display])
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    if !params.nil?
      project = Myp.find_existing_object(Project.name, params["project_id"])
      result.top = project.default_to_top
    end
    result
  end

  def self.skip_check_attributes
    ["top"]
  end
end
