class VehicleService < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

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
    if MyplaceonlineExecutionContext.handle_updates?
      if !date_serviced.nil?
        CalendarItem.destroy_calendar_items(User.current_user.current_identity, self.class, model_id: id)
      elsif !date_due.nil?
        ApplicationRecord.transaction do
          CalendarItem.destroy_calendar_items(User.current_user.current_identity, self.class, model_id: id)
          User.current_user.current_identity.calendars.each do |calendar|
            CalendarItem.create_calendar_item(
              identity: User.current_user.current_identity,
              calendar: calendar,
              model: self.class,
              calendar_item_time: date_due,
              reminder_threshold_amount: (calendar.vehicle_service_threshold_seconds || DEFAULT_VEHICLE_SERVICE_THRESHOLD_SECONDS),
              reminder_threshold_type: Calendar::DEFAULT_REMINDER_TYPE,
              model_id: id
            )
          end
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(User.current_user.current_identity, self.class, model_id: self.id)
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.date_serviced = User.current_user.date_now
    result
  end

  child_files

  def file_folders_parent
    :vehicle
  end
end
