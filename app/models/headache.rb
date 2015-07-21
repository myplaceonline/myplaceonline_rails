class Headache < ActiveRecord::Base
  belongs_to :owner, class_name: Identity
  
  validates :started, presence: true
  
  def display
    result = Myp.display_datetime_short(started, User.current_user)
    if !headache_location.blank?
      result += " (" + headache_location + ")"
    end
    result
  end

  before_create :do_before_save
  before_update :do_before_save
  
  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
