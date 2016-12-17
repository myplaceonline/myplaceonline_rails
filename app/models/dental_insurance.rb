class DentalInsurance < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ModelHelpersConcern
  
  validates :insurance_name, presence: true
  
  def display
    insurance_name
  end
  
  belongs_to :insurance_company, class_name: Company
  accepts_nested_attributes_for :insurance_company, reject_if: proc { |attributes| CompaniesController.reject_if_blank(attributes) }
  allow_existing :insurance_company, Company

  belongs_to :group_company, class_name: Company
  accepts_nested_attributes_for :group_company, reject_if: proc { |attributes| CompaniesController.reject_if_blank(attributes) }
  allow_existing :group_company, Company

  belongs_to :periodic_payment
  accepts_nested_attributes_for :periodic_payment, reject_if: proc { |attributes| PeriodicPaymentsController.reject_if_blank(attributes) }
  allow_existing :periodic_payment

  belongs_to :password
  accepts_nested_attributes_for :password, reject_if: proc { |attributes| PasswordsController.reject_if_blank(attributes) }
  allow_existing :password
  
  belongs_to :doctor
  accepts_nested_attributes_for :doctor, reject_if: proc { |attributes| DoctorsController.reject_if_blank(attributes) }
  allow_existing :doctor
  
  after_commit :on_after_create, on: :create
  
  def on_after_create
    if MyplaceonlineExecutionContext.handle_updates?
      last_dentist_visit = DentistVisit.last_cleaning(
        User.current_user.primary_identity
      )

      if last_dentist_visit.nil?
        User.current_user.primary_identity.calendars.each do |calendar|
          # If there are no dental visits for a cleaning and there is dental
          # insurance, then create a persistent reminder to get a dental
          # cleaning (if one doesn't already exist)
          CalendarItem.ensure_persistent_calendar_item(
            User.current_user.primary_identity,
            calendar,
            DentistVisit
          )
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    if Myp.count(DentalInsurance, User.current_user.primary_identity) == 0
      CalendarItem.destroy_calendar_items(
        User.current_user.primary_identity,
        DentistVisit
      )
    end
  end

  has_many :dental_insurance_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :dental_insurance_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :dental_insurance_files, [{:name => :identity_file}]

  before_validation :update_file_folders

  def update_file_folders
    put_files_in_folder(dental_insurance_files, [I18n.t("myplaceonline.category.dental_insurances"), display])
  end
end
