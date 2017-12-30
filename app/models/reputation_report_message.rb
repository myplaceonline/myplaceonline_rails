class ReputationReportMessage < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :message, type: ApplicationRecord::PROPERTY_TYPE_CHILD }
    ]
  end
  
  def display
    self.message.display
  end

  belongs_to :reputation_report

  child_property(name: :message, required: true)
  
  child_files

  def self.params
    [
      :id,
      :_destroy,
      message_attributes: MessagesController.param_names,
      reputation_report_message_files_attributes: FilesController.multi_param_names,
    ]
  end

  def read_only?(action: nil)
    !User.current_user.admin?
  end
  
  def allow_admin?
    true
  end
end
