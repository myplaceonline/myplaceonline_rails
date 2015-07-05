class Hypothesis < ActiveRecord::Base
  belongs_to :question
  belongs_to :owner, class: Identity

  validates :name, presence: true

  has_many :hypothesis_experiments, :dependent => :destroy
  accepts_nested_attributes_for :hypothesis_experiments, allow_destroy: true, reject_if: :all_blank

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
