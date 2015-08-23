class Pain < MyplaceonlineIdentityRecord
  validates :pain_start_time, presence: true
  
  def display
    result = Myp.display_datetime_short(pain_start_time, User.current_user)
    if !pain_location.blank?
      result += " (" + pain_location + ")"
    end
    result
  end
  
  def self.build(params = nil)
    result = super(params)
    result.pain_start_time = DateTime.now
    result
  end
end
