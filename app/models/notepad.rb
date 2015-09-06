class Notepad < MyplaceonlineIdentityRecord
  validates :title, presence: true
  
  def display
    title
  end
end
