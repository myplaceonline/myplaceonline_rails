class VehicleInsurance < ActiveRecord::Base
  belongs_to :vehicle
  belongs_to :company
  belongs_to :periodic_payment
  belongs_to :identity

  validates :insurance_name, presence: true

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
