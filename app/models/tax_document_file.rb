class TaxDocumentFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :tax_document

  child_property(name: :identity_file, required: true)
end
