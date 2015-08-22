class MedicalConditionInstance < MyplaceonlineActiveRecord
  belongs_to :medical_condition
  validates :condition_start, presence: true
  
  def display
    Myp.display_datetime_short(condition_start, User.current_user)
  end
end
