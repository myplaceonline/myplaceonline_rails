class FavoriteProduct < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :product_name, presence: true
  
  child_properties(name: :favorite_product_links)

  def display
    product_name
  end

  child_files
end
