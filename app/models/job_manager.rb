class JobManager < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :job

  child_property(name: :contact, required: true)
end
