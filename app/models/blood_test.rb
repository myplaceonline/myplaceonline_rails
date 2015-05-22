class BloodTest < ActiveRecord::Base
  belongs_to :identity
  validates :fast_started, presence: true
  
  def display
    Myp.display_datetime_short(fast_started, User.current_user)
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
