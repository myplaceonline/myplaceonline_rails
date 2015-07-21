class VehicleInsurance < ActiveRecord::Base
  belongs_to :vehicle
  belongs_to :owner, class_name: Identity

  validates :insurance_name, presence: true

  belongs_to :company
  accepts_nested_attributes_for :company, allow_destroy: true, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def company_attributes=(attributes)
    if !attributes['id'].blank?
      self.company = Company.find(attributes['id'])
    end
    super
  end

  belongs_to :periodic_payment
  accepts_nested_attributes_for :periodic_payment, allow_destroy: true, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def periodic_payment_attributes=(attributes)
    if !attributes['id'].blank?
      self.periodic_payment = PeriodicPayment.find(attributes['id'])
    end
    super
  end

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
