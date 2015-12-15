class DiaryEntry < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :diary_time, presence: true
  validates :entry, presence: true
  
  def display
    if diary_title.blank?
      Myp.display_datetime_short(diary_time, User.current_user)
    else
      diary_title + " (" + Myp.display_datetime_short(diary_time, User.current_user) + ")"
    end
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.diary_time = DateTime.now
    result
  end
end
