class HypothesisExperiment < MyplaceonlineActiveRecord
  belongs_to :hypothesis

  validates :name, presence: true
end
