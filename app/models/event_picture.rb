class EventPicture < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :event

  child_property(name: :identity_file, required: true)
end
