class DentistVisit < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ModelHelpersConcern
  
  DEFAULT_DENTIST_VISIT_THRESHOLD_SECONDS = 6.months
  
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
    result = self.dobuild(params)
    result.visit_date = DateTime.now
    result.cleaning = true
    result
  end
  
  def self.calendar_item_display(calendar_item)
    if calendar_item.calendar_item_time.nil?
      I18n.t("myplaceonline.dentist_visits.no_cleanings")
    else
      I18n.t(
        "myplaceonline.dentist_visits.no_cleaning_for",
        delta: Myp.time_delta(calendar_item.calendar_item_time)
      )
    end
  end
  
  def self.last_cleaning(identity)
    DentistVisit.where(
      identity: identity,
      cleaning: true
    ).order('visit_date DESC').limit(1).first
  end

  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    last_dentist_visit = DentistVisit.last_cleaning(
      User.current_user.primary_identity,
    )

    if !last_dentist_visit.nil?
      ActiveRecord::Base.transaction do
        CalendarItem.destroy_calendar_items(
          User.current_user.primary_identity,
          DentistVisit
        )

        User.current_user.primary_identity.calendars.each do |calendar|
          CalendarItem.create_calendar_item(
            User.current_user.primary_identity,
            calendar,
            DentistVisit,
            last_dentist_visit.visit_date + (calendar.dentist_visit_threshold_seconds || DEFAULT_DENTIST_VISIT_THRESHOLD_SECONDS).seconds,
            Calendar::DEFAULT_REMINDER_AMOUNT,
            Calendar::DEFAULT_REMINDER_TYPE
          )
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    last_dentist_visit = DentistVisit.last_cleaning(
      User.current_user.primary_identity,
    )
    
    if last_dentist_visit.nil?
      CalendarItem.destroy_calendar_items(
        User.current_user.primary_identity,
        DentistVisit
      )
      DentalInsurance.new.on_after_create
    else
      on_after_save
    end
  end
end
