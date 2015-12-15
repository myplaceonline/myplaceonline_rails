class SunExposure < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :exposure_start, presence: true
  
  def display
    Myp.display_datetime(exposure_start, User.current_user)
  end
    
  def self.build(params = nil)
    result = self.dobuild(params)
    result.exposure_start = DateTime.now
    result
  end
end
