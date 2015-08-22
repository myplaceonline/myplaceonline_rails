class DiaryEntry < MyplaceonlineActiveRecord
  validates :diary_time, presence: true
  validates :entry, presence: true
  
  def display
    Myp.display_datetime_short(diary_time, User.current_user)
  end
end
