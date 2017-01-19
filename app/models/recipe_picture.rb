class RecipePicture < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :recipe

  child_property(name: :identity_file, required: true)
end
