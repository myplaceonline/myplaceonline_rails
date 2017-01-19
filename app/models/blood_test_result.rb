class BloodTestResult < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :blood_test

  child_property(name: :blood_concentration)
end
