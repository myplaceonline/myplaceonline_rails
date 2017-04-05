class CompanyInteraction < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :company_interaction_date, type: ApplicationRecord::PROPERTY_TYPE_DATE },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :company_interaction_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end
  
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
