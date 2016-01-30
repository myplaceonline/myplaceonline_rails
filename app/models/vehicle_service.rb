class VehicleService < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  DEFAULT_VEHICLE_SERVICE_THRESHOLD_SECONDS = 15.days

  belongs_to :vehicle
  validates :short_description, presence: true
  
  def display
    short_description
  end

  def self.calendar_item_display(calendar_item)
    calendar_item.find_model_object.display
  end
  
  def self.calendar_item_link(calendar_item)
    Rails.application.routes.url_helpers.send("vehicle_path", calendar_item.find_model_object.vehicle)
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if !date_serviced.nil?
      CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: id)
    elsif !date_due.nil?
      ActiveRecord::Base.transaction do
        CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: id)
        User.current_user.primary_identity.calendars.each do |calendar|
          CalendarItem.create_calendar_item(
            User.current_user.primary_identity,
            calendar,
            self.class,
            date_due,
            (calendar.vehicle_service_threshold_seconds || DEFAULT_VEHICLE_SERVICE_THRESHOLD_SECONDS),
            Calendar::DEFAULT_REMINDER_TYPE,
            model_id: id
          )
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, self.id)
  end
end
