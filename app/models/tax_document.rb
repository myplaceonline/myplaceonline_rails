class TaxDocument < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :tax_document_form_name, presence: true
  
  def display
    Myp.appendstrwrap(tax_document_form_name, tax_document_description)
  end

  has_many :tax_document_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :tax_document_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :tax_document_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(tax_document_files, [I18n.t("myplaceonline.category.tax_documents"), display])
  end
end
