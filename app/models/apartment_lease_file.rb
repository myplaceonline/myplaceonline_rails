class ApartmentLeaseFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :apartment_lease

  child_property(name: :identity_file, required: true)
end
