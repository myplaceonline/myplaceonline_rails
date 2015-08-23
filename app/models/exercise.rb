class Exercise < MyplaceonlineIdentityRecord
  validates :exercise_start, presence: true
  
  def display
    Myp.display_datetime(exercise_start, User.current_user)
  end
  
  def self.build(params = nil)
    result = super(params)
    result.exercise_start = DateTime.now
    result
  end
end
