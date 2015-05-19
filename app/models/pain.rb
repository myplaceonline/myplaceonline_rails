class Pain < ActiveRecord::Base
  belongs_to :identity
  
  validates :pain_start_time, presence: true
  
  def display
    Myp.display_datetime(pain_start_time, User.current_user)
  end

  before_create :do_before_save
  before_update :do_before_save
  
  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
