class PrescriptionFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :prescription

  child_property(name: :identity_file, required: true)
end
