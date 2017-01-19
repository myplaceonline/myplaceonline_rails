class QuestFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :quest

  child_property(name: :identity_file, required: true)
end
