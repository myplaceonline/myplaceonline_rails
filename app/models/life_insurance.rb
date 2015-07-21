class LifeInsurance < ActiveRecord::Base
  
  LIFE_INSURANCE_TYPES = [
    ["myplaceonline.life_insurances.type_whole", 0],
    ["myplaceonline.life_insurances.type_term", 1]
  ]

  belongs_to :owner, class_name: Identity
  validates :insurance_name, presence: true
  validates :insurance_amount, presence: true
  
  def display
    result = insurance_name
    if !insurance_amount.blank?
      result += " (" + Myp.display_currency(insurance_amount, User.current_user) + ")"
    end
    result
  end
  
  belongs_to :company
  accepts_nested_attributes_for :company, reject_if: proc { |attributes| CompaniesController.reject_if_blank(attributes) }
  
  # http://stackoverflow.com/a/12064875/4135310
  def company_attributes=(attributes)
    if !attributes['id'].blank?
      attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
      self.company = Company.find(attributes['id'])
    end
    super
  end

  belongs_to :periodic_payment
  accepts_nested_attributes_for :periodic_payment, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def periodic_payment_attributes=(attributes)
    if !attributes['id'].blank?
      attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
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
