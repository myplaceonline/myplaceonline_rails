class MedicalConditionTreatment < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :medical_condition
  belongs_to :doctor

  validates :treatment_date, presence: true
  
  def display
    Myp.display_date_short_year(treatment_date, User.current_user)
  end
end
