class TripPicture < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :trip
  
  child_property(name: :identity_file, required: true)
end
