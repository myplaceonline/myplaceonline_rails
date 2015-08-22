class Subscription < MyplaceonlineActiveRecord
  validates :name, presence: true
  
  def display
    name
  end
end
