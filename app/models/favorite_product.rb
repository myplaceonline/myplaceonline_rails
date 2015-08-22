class FavoriteProduct < MyplaceonlineActiveRecord
  validates :product_name, presence: true
  
  def display
    product_name
  end
end
