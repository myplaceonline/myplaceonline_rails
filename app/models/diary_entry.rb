class DiaryEntry < ActiveRecord::Base
  belongs_to :owner, class: Identity
  validates :diary_time, presence: true
  validates :entry, presence: true
  
  def display
    Myp.display_datetime_short(diary_time, User.current_user)
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
