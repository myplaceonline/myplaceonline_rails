class HypothesisExperiment < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :hypothesis

  validates :name, presence: true
end
