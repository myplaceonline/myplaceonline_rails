class VehicleInsurance < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :vehicle
  belongs_to :owner, class_name: Identity

  validates :insurance_name, presence: true

  belongs_to :company
  accepts_nested_attributes_for :company, allow_destroy: true, reject_if: :all_blank
  allow_existing :company

  belongs_to :periodic_payment
  accepts_nested_attributes_for :periodic_payment, allow_destroy: true, reject_if: :all_blank
  allow_existing :periodic_payment

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
