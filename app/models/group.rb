class Group < MyplaceonlineIdentityRecord
  validates :group_name, presence: true
  
  def display
    group_name
  end
end
