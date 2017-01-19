class BusinessCardFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :business_card

  child_property(name: :identity_file, required: true)
end
