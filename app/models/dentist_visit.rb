class DentistVisit < MyplaceonlineIdentityRecord
  include AllowExistingConcern
  include ModelHelpersConcern
  
  validates :visit_date, presence: true
  
  def display
    Myp.display_datetime_short(visit_date, User.current_user)
  end
  
  belongs_to :dental_insurance
  accepts_nested_attributes_for :dental_insurance, reject_if: proc { |attributes| DentalInsurancesController.reject_if_blank(attributes) }
  allow_existing :dental_insurance
  
  belongs_to :dentist, class_name: Doctor
  accepts_nested_attributes_for :dentist, reject_if: proc { |attributes| DoctorsController.reject_if_blank(attributes) }
  allow_existing :dentist, Doctor
  
  def self.build(params = nil)
    result = super(params)
    result.visit_date = DateTime.now
    result
  end
end
