class MedicalCondition < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :medical_condition_name, presence: true
  
  def display
    medical_condition_name
  end
  
  child_properties(name: :medical_condition_instances, sort: "condition_start DESC")

  child_properties(name: :medical_condition_treatments, sort: "treatment_date DESC")

  child_properties(name: :medical_condition_evaluations, sort: "evaluation_datetime DESC")
end
