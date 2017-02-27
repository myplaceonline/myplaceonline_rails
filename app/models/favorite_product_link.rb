class FavoriteProductLink < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :favorite_product
  
  validates :link, presence: true
  
  def final_search_result
    favorite_product
  end
end
