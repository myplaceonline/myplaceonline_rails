class MedicalCondition < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :medical_condition_name, presence: true
  
  def display
    medical_condition_name
  end
  
  has_many :medical_condition_instances, -> { order('condition_start DESC') }, :dependent => :destroy
  accepts_nested_attributes_for :medical_condition_instances, allow_destroy: true, reject_if: :all_blank

  has_many :medical_condition_treatments, -> { order('treatment_date DESC') }, :dependent => :destroy
  accepts_nested_attributes_for :medical_condition_treatments, allow_destroy: true, reject_if: :all_blank
end
