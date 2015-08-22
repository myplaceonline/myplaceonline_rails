class Pain < MyplaceonlineActiveRecord
  validates :pain_start_time, presence: true
  
  def display
    result = Myp.display_datetime_short(pain_start_time, User.current_user)
    if !pain_location.blank?
      result += " (" + pain_location + ")"
    end
    result
  end
end
