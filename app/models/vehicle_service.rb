class VehicleService < ActiveRecord::Base
  belongs_to :identity
  belongs_to :vehicle
  validates :short_description, presence: true
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
