class VaccineFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :vaccine

  child_property(name: :identity_file, required: true)
end
