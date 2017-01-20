class Document < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :document_name, presence: true
  
  def display
    document_name
  end

  child_files

  def self.skip_check_attributes
    ["important"]
  end
end
