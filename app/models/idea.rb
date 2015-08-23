class Idea < MyplaceonlineIdentityRecord
  validates :name, presence: true
  
  def display
    name
  end
end
