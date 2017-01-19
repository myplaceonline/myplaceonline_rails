class ProblemReportFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :problem_report

  child_property(name: :identity_file, required: true)
end
