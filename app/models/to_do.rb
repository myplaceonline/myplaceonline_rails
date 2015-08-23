class ToDo < MyplaceonlineIdentityRecord
  validates :short_description, presence: true
  
  def display
    short_description
  end
end
