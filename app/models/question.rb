class Question < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :name, presence: true
  
  child_properties(name: :hypotheses)
  
  def display
    name
  end

  def all_hypotheses
    Hypothesis.where(question_id: id).order(["hypotheses.position ASC"])
  end
end
