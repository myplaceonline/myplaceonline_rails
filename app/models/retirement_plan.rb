class RetirementPlan < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  
  RETIREMENT_PLAN_TYPES = [
    ["myplaceonline.retirement_plans.type_social_security", 0],
    ["myplaceonline.retirement_plans.type_401k", 1]
  ]

  validates :retirement_plan_name, presence: true
  
  def display
    retirement_plan_name
  end
  
  belongs_to :company
  accepts_nested_attributes_for :company, reject_if: proc { |attributes| CompaniesController.reject_if_blank(attributes) }
  allow_existing :company

  belongs_to :periodic_payment
  accepts_nested_attributes_for :periodic_payment, reject_if: :all_blank
  allow_existing :periodic_payment
  
  belongs_to :password
  accepts_nested_attributes_for :password, reject_if: proc { |attributes| PasswordsController.reject_if_blank(attributes) }
  allow_existing :password

  has_many :retirement_plan_amounts, :dependent => :destroy
  accepts_nested_attributes_for :retirement_plan_amounts, allow_destroy: true, reject_if: :all_blank
end
