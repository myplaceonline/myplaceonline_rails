class StoryPicture < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :story

  child_property(name: :identity_file, required: true)
end
