class RetirementPlan < ApplicationRecord
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
  
  child_property(name: :company)

  child_property(name: :periodic_payment)
  
  child_property(name: :password)

  child_properties(name: :retirement_plan_amounts)
end
