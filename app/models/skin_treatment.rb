class SkinTreatment < ActiveRecord::Base
  belongs_to :owner, class_name: Identity
  validates :treatment_time, presence: true
  
  def display
    result = Myp.display_datetime_short(treatment_time, User.current_user)
    result
  end

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
