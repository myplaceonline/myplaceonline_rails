class PsychologicalEvaluationFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_file(parent: :psychological_evaluation)
end
