class Wisdom < MyplaceonlineIdentityRecord
  validates :name, presence: true
  
  def display
    name
  end
end
