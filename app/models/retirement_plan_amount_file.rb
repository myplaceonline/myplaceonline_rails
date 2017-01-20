class RetirementPlanAmountFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_file(parent: :retirement_plan_amount)
end
