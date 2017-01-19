class MedicalConditionEvaluationFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :medical_condition_evaluation

  child_property(name: :identity_file, required: true)
end
