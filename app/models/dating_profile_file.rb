class DatingProfileFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_file(parent: :dating_profile)
end
