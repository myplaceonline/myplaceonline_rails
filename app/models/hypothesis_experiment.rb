class HypothesisExperiment < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :hypothesis

  validates :name, presence: true
end
