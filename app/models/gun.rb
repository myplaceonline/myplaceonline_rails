class Gun < MyplaceonlineActiveRecord
  validates :gun_name, presence: true
  
  def display
    gun_name
  end
end
