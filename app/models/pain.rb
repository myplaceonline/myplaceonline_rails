class Pain < ActiveRecord::Base
  belongs_to :owner, class: Identity
  
  validates :pain_start_time, presence: true
  
  def display
    result = Myp.display_datetime_short(pain_start_time, User.current_user)
    if !pain_location.blank?
      result += " (" + pain_location + ")"
    end
    result
  end

  before_create :do_before_save
  before_update :do_before_save
  
  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
