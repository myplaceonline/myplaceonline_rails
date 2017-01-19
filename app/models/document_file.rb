class DocumentFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :document

  child_property(name: :identity_file, required: true)
end
