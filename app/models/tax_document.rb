class TaxDocument < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :tax_document_form_name, presence: true
  
  def display
    Myp.appendstrwrap(tax_document_form_name, tax_document_description)
  end

  child_files
end
