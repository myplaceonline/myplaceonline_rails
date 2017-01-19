class ItemFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :item

  child_property(name: :identity_file, required: true)
end
