class EducationFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :education

  child_property(name: :identity_file, required: true)
end
