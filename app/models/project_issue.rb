class ProjectIssue < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ModelHelpersConcern

  attr_accessor :top

  attr_accessor :is_archived
  boolean_time_transfer :is_archived, :archived

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

  has_many :project_issue_files, :dependent => :destroy
  accepts_nested_attributes_for :project_issue_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :project_issue_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(project_issue_files, [I18n.t("myplaceonline.category.projects"), project.display])
  end
end
