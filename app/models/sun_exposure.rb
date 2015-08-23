class SunExposure < MyplaceonlineIdentityRecord
  validates :exposure_start, presence: true
  
  def display
    Myp.display_datetime(exposure_start, User.current_user)
  end
end
