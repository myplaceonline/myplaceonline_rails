class LocationPhone < ActiveRecord::Base
  belongs_to :owner, class: Identity
  belongs_to :location
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
