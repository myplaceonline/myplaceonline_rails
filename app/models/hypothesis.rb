class Hypothesis < MyplaceonlineActiveRecord
  belongs_to :question

  validates :name, presence: true

  has_many :hypothesis_experiments, :dependent => :destroy
  accepts_nested_attributes_for :hypothesis_experiments, allow_destroy: true, reject_if: :all_blank
end
