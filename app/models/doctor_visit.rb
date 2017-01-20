class DoctorVisit < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ModelHelpersConcern
  
  DEFAULT_DOCTOR_VISIT_THRESHOLD_SECONDS = 12.months

  validates :visit_date, presence: true
  
  def display
    Myp.display_datetime_short_year(visit_date, User.current_user)
  end
  
  child_property(name: :health_insurance)
  
  child_property(name: :doctor)
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.visit_date = DateTime.now
    result
  end

  
  def self.calendar_item_display(calendar_item)
    if calendar_item.calendar_item_time.nil?
      I18n.t("myplaceonline.doctor_visits.no_physicals")
    else
      I18n.t(
        "myplaceonline.doctor_visits.next_physical",
        delta: Myp.time_delta(calendar_item.calendar_item_time)
      )
    end
  end
  
  def self.last_physical(identity)
    DoctorVisit.where(
      identity: identity,
      physical: true
    ).order('visit_date DESC').limit(1).first
  end

  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if MyplaceonlineExecutionContext.handle_updates?
      last_physical = DoctorVisit.last_physical(
        User.current_user.primary_identity,
      )

      if !last_physical.nil?
        ApplicationRecord.transaction do
          CalendarItem.destroy_calendar_items(
            User.current_user.primary_identity,
            DoctorVisit
          )

          User.current_user.primary_identity.calendars.each do |calendar|
            CalendarItem.create_calendar_item(
              identity: User.current_user.primary_identity,
              calendar: calendar,
              model: DoctorVisit,
              calendar_item_time: last_physical.visit_date + (calendar.doctor_visit_threshold_seconds || DEFAULT_DOCTOR_VISIT_THRESHOLD_SECONDS).seconds,
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
    last_physical = DoctorVisit.last_physical(
      User.current_user.primary_identity,
    )
    
    if last_physical.nil?
      CalendarItem.destroy_calendar_items(
        User.current_user.primary_identity,
        DoctorVisit
      )
      HealthInsurance.new.on_after_create
    else
      on_after_save
    end
  end

  def self.skip_check_attributes
    ["physical"]
  end
  
  child_files
end
