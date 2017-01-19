class BloodTestFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :blood_test

  child_property(name: :identity_file, required: true)
end
