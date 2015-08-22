class HealthInsurance < MyplaceonlineActiveRecord
  include AllowExistingConcern
  
  validates :insurance_name, presence: true
  
  def display
    insurance_name
  end
  
  belongs_to :insurance_company, class_name: Company
  accepts_nested_attributes_for :insurance_company, reject_if: proc { |attributes| CompaniesController.reject_if_blank(attributes) }
  allow_existing :insurance_company, Company

  belongs_to :group_company, class_name: Company
  accepts_nested_attributes_for :group_company, reject_if: proc { |attributes| CompaniesController.reject_if_blank(attributes) }
  allow_existing :group_company, Company

  belongs_to :periodic_payment
  accepts_nested_attributes_for :periodic_payment, reject_if: :all_blank
  allow_existing :periodic_payment

  belongs_to :password
  accepts_nested_attributes_for :password, reject_if: proc { |attributes| PasswordsController.reject_if_blank(attributes) }
  allow_existing :password
  
  attr_accessor :is_defunct
end
