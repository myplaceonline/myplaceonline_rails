class Document < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :document_name, presence: true
  
  def display
    document_name
  end

  child_properties(name: :document_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(document_files, [I18n.t("myplaceonline.category.documents"), display])
  end

  def self.skip_check_attributes
    ["important"]
  end
end
