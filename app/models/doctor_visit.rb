class DoctorVisit < MyplaceonlineIdentityRecord
  include AllowExistingConcern
  include ModelHelpersConcern
  
  validates :visit_date, presence: true
  
  def display
    Myp.display_datetime_short(visit_date, User.current_user)
  end
  
  belongs_to :health_insurance
  accepts_nested_attributes_for :health_insurance, reject_if: proc { |attributes| HealthInsurancesController.reject_if_blank(attributes) }
  allow_existing :health_insurance
  
  belongs_to :doctor
  accepts_nested_attributes_for :doctor, reject_if: proc { |attributes| DoctorsController.reject_if_blank(attributes) }
  allow_existing :doctor
  
  def self.build(params = nil)
    result = super(params)
    result.visit_date = DateTime.now
    result
  end

  after_save { |record| DueItem.due_physicals(User.current_user, record, DueItem::UPDATE_TYPE_UPDATE) }
  after_destroy { |record| DueItem.due_physicals(User.current_user, record, DueItem::UPDATE_TYPE_DELETE) }
end
