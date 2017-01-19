class FavoriteProductFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :favorite_product

  child_property(name: :identity_file, required: true)
end
