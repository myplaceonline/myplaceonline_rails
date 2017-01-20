class ProblemReport < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :report_name, presence: true
  
  def display
    report_name
  end

  child_files
end
