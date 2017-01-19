class BarPicture < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :bar

  child_property(name: :identity_file, required: true)
end
