class HypothesisExperiment < MyplaceonlineIdentityRecord
  belongs_to :hypothesis

  validates :name, presence: true
end
