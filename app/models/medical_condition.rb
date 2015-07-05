class MedicalCondition < ActiveRecord::Base
  belongs_to :owner, class: Identity
  validates :medical_condition_name, presence: true
  
  def display
    medical_condition_name
  end
  
  has_many :medical_condition_instances, -> { order('condition_start DESC') }, :dependent => :destroy
  accepts_nested_attributes_for :medical_condition_instances, allow_destroy: true, reject_if: :all_blank

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
