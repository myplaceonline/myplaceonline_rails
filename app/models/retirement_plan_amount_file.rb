class RetirementPlanAmountFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :retirement_plan_amount

  child_property(name: :identity_file, required: true)
end
