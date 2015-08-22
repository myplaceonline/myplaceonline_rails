class Website < MyplaceonlineActiveRecord
  validates :url, presence: true
  
  def display
    title
  end
end
