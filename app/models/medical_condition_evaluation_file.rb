class MedicalConditionEvaluationFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_file(parent: :medical_condition_evaluation)
end
