class MedicalConditionEvaluation < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :medical_condition
  
  validates :evaluation_datetime, presence: true
  
  def display
    Myp.appendstrwrap(medical_condition.display, Myp.display_datetime_short(self.evaluation_datetime, User.current_user))
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :evaluation_datetime,
      :notes
    ]
  end
end
