class Gun < MyplaceonlineIdentityRecord
  validates :gun_name, presence: true
  
  def display
    gun_name
  end
end
