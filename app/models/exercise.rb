class Exercise < MyplaceonlineIdentityRecord
  validates :exercise_start, presence: true
  
  def display
    Myp.display_datetime(exercise_start, User.current_user)
  end
end
