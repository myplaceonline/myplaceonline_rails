class PsychologicalEvaluation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :psychological_evaluation_name, presence: true
  
  def display
    psychological_evaluation_name
  end

  child_files

  child_property(name: :evaluator, model: Contact)
end
