class TherapistPhone < ActiveRecord::Base
  belongs_to :owner, class_name: Identity
  belongs_to :therapist
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
