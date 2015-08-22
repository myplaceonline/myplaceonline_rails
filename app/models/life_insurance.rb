class LifeInsurance < MyplaceonlineActiveRecord
  include AllowExistingConcern
  
  LIFE_INSURANCE_TYPES = [
    ["myplaceonline.life_insurances.type_whole", 0],
    ["myplaceonline.life_insurances.type_term", 1]
  ]

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
  allow_existing :company

  belongs_to :periodic_payment
  accepts_nested_attributes_for :periodic_payment, reject_if: :all_blank
  allow_existing :periodic_payment
end
