class Hypothesis < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :question

  validates :name, presence: true

  child_properties(name: :hypothesis_experiments)
  
  def final_search_result
    question
  end
end
