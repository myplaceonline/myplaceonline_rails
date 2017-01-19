class RestaurantPicture < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :restaurant

  child_property(name: :identity_file, required: true)
end
