class CompanyInteraction < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :company
  
  validates :company_interaction_date, presence: true
  
  def display
    Myp.appendstrwrap(company.display, Myp.display_datetime_short(self.company_interaction_date, User.current_user))
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :company_interaction_date,
      :notes,
      company_interaction_files_attributes: FilesController.multi_param_names
    ]
  end

  child_files

  def file_folders_parent
    :company
  end
end
