class DentistVisit < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ModelHelpersConcern
  
  DEFAULT_DENTIST_VISIT_THRESHOLD_SECONDS = 6.months
  
  validates :visit_date, presence: true
  
  def display
    Myp.display_date_short_year(visit_date, User.current_user)
  end
  
  child_property(name: :dental_insurance)
  
  child_property(name: :dentist, model: Doctor)
  
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
        "myplaceonline.dentist_visits.next_cleaning",
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
    if MyplaceonlineExecutionContext.handle_updates?
      last_dentist_visit = DentistVisit.last_cleaning(
        User.current_user.current_identity,
      )

      if !last_dentist_visit.nil?
        ApplicationRecord.transaction do
          CalendarItem.destroy_calendar_items(
            User.current_user.current_identity,
            DentistVisit
          )

          User.current_user.current_identity.calendars.each do |calendar|
            CalendarItem.create_calendar_item(
              identity: User.current_user.current_identity,
              calendar: calendar,
              model: DentistVisit,
              calendar_item_time: last_dentist_visit.visit_date + (calendar.dentist_visit_threshold_seconds || DEFAULT_DENTIST_VISIT_THRESHOLD_SECONDS).seconds,
              reminder_threshold_amount: Calendar::DEFAULT_REMINDER_AMOUNT,
              reminder_threshold_type: Calendar::DEFAULT_REMINDER_TYPE
            )
          end
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    last_dentist_visit = DentistVisit.last_cleaning(
      User.current_user.current_identity,
    )
    
    if last_dentist_visit.nil?
      CalendarItem.destroy_calendar_items(
        User.current_user.current_identity,
        DentistVisit
      )
      DentalInsurance.new.on_after_create
    else
      on_after_save
    end
  end

  def self.skip_check_attributes
    ["cleaning"]
  end
end
