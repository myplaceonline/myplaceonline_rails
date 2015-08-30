class Status < MyplaceonlineIdentityRecord
  validates :status_time, presence: true
  
  def display
    Myp.display_datetime(status_time, User.current_user)
  end
  
  def self.build(params = nil)
    result = super(params)
    result.status_time = DateTime.now
    result
  end
end
