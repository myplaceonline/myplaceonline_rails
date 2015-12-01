class SkinTreatment < MyplaceonlineIdentityRecord
  validates :treatment_time, presence: true
  
  def display
    result = Myp.display_datetime_short(treatment_time, User.current_user)
    result
  end
end
