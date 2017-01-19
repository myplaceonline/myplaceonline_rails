class ApartmentPicture < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :apartment

  child_property(name: :identity_file, required: true)
end
