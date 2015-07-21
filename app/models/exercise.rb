class Exercise < ActiveRecord::Base
  belongs_to :owner, class_name: Identity
  
  validates :exercise_start, presence: true
  
  def display
    Myp.display_datetime(exercise_start, User.current_user)
  end

  before_create :do_before_save
  before_update :do_before_save
  
  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
