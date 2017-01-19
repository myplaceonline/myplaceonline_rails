class FavoriteProductLink < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :favorite_product
  
  validates :link, presence: true
end
