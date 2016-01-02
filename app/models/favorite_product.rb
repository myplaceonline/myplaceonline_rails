class FavoriteProduct < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :product_name, presence: true
  
  has_many :favorite_product_links, :dependent => :destroy
  accepts_nested_attributes_for :favorite_product_links, allow_destroy: true, reject_if: :all_blank

  def display
    product_name
  end
end
