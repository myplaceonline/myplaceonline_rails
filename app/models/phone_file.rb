class PhoneFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :phone

  child_property(name: :identity_file, required: true)
end
