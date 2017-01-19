class TaxDocument < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :tax_document_form_name, presence: true
  
  def display
    Myp.appendstrwrap(tax_document_form_name, tax_document_description)
  end

  child_properties(name: :tax_document_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(tax_document_files, [I18n.t("myplaceonline.category.tax_documents"), display])
  end
end
