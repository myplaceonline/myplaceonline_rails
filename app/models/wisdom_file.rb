class WisdomFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :wisdom

  child_property(name: :identity_file, required: true)
end
