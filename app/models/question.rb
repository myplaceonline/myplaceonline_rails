class Question < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :name, presence: true
  
  has_many :hypotheses, :dependent => :destroy
  accepts_nested_attributes_for :hypotheses, allow_destroy: true, reject_if: :all_blank
  
  def display
    name
  end

  def all_hypotheses
    Hypothesis.where(question_id: id).order(["hypotheses.position ASC"])
  end
end
