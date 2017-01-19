class MedicalConditionTreatment < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :medical_condition

  child_property(name: :doctor)

  child_property(name: :location)

  validates :treatment_date, presence: true
  
  def display
    Myp.display_date_short_year(treatment_date, User.current_user)
  end
end
