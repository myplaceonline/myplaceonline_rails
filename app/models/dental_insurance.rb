class DentalInsurance < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ModelHelpersConcern
  
  validates :insurance_name, presence: true
  
  def display
    insurance_name
  end
  
  child_property(name: :insurance_company, model: Company)

  child_property(name: :group_company, model: Company)

  child_property(name: :periodic_payment)

  child_property(name: :password)
  
  child_property(name: :doctor)
  
  after_commit :on_after_create, on: :create
  
  def on_after_create
    if MyplaceonlineExecutionContext.handle_updates?
      last_dentist_visit = DentistVisit.last_cleaning(
        User.current_user.current_identity
      )

      if last_dentist_visit.nil?
        User.current_user.current_identity.calendars.each do |calendar|
          # If there are no dental visits for a cleaning and there is dental
          # insurance, then create a persistent reminder to get a dental
          # cleaning (if one doesn't already exist)
          CalendarItem.ensure_persistent_calendar_item(
            User.current_user.current_identity,
            calendar,
            DentistVisit
          )
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    if Myp.count(DentalInsurance, User.current_user.current_identity) == 0
      CalendarItem.destroy_calendar_items(
        User.current_user.current_identity,
        DentistVisit
      )
    end
  end

  child_files
end
