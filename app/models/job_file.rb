class JobFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :job

  child_property(name: :identity_file, required: true)
end
