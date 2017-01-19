class BookFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :book

  child_property(name: :identity_file, required: true)
end
