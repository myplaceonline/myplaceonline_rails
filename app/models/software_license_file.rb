class SoftwareLicenseFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_file(parent: :software_license)
end
