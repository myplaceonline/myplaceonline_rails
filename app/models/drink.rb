class Drink < MyplaceonlineIdentityRecord
  validates :drink_name, presence: true

  def display
    drink_name
  end
  
  def self.params
    [
      :id,
      :drink_name,
      :notes,
      :calories,
      :price
    ]
  end
end
