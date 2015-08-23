class Website < MyplaceonlineIdentityRecord
  validates :url, presence: true
  
  def display
    title
  end
end
