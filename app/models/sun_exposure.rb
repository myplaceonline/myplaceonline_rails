class SunExposure < MyplaceonlineIdentityRecord
  validates :exposure_start, presence: true
  
  def display
    Myp.display_datetime(exposure_start, User.current_user)
  end
    
  def self.build(params = nil)
    result = super(params)
    result.exposure_start = DateTime.now
    result
  end
end
