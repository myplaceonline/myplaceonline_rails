class PassportPicture < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :passport

  child_property(name: :identity_file, required: true)
end
