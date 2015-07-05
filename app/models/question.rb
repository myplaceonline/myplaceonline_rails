class Question < ActiveRecord::Base
  belongs_to :owner, class: Identity
  validates :name, presence: true
  
  has_many :hypotheses, :dependent => :destroy
  accepts_nested_attributes_for :hypotheses, allow_destroy: true, reject_if: :all_blank
  
  def display
    name
  end

  before_create :do_before_save
  before_update :do_before_save
  
  def all_hypotheses
    Hypothesis.where(question_id: id).order(["hypotheses.position ASC"])
  end

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
