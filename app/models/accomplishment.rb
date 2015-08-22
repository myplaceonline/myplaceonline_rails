class Accomplishment < MyplaceonlineActiveRecord
  validates :name, presence: true
  
  def display
    name
  end
end
