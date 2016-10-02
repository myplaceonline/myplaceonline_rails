class GunRegistration < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  DEFAULT_GUN_REGISTRATION_EXPIRATION_THRESHOLD_SECONDS = 60.days

  belongs_to :gun
  validates :expires, presence: true
  
  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location

  def display
    Myp.display_date(expires, User.current_user)
  end

  def self.calendar_item_display(calendar_item)
    gun_registration = calendar_item.find_model_object
    I18n.t(
      "myplaceonline.gun_registrations.expires_soon",
      gun_name: gun_registration.gun.display,
      delta: Myp.time_delta(gun_registration.expires)
    )
  end

  def self.calendar_item_link(calendar_item)
    Rails.application.routes.url_helpers.send("gun_path", calendar_item.find_model_object.gun)
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if MyplaceonlineExecutionContext.handle_updates?
      ActiveRecord::Base.transaction do
        CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: id)
        User.current_user.primary_identity.calendars.each do |calendar|
          CalendarItem.create_calendar_item(
            identity: User.current_user.primary_identity,
            calendar: calendar,
            model: self.class,
            calendar_item_time: expires,
            reminder_threshold_amount: (calendar.gun_registration_expiration_threshold_seconds || DEFAULT_GUN_REGISTRATION_EXPIRATION_THRESHOLD_SECONDS),
            reminder_threshold_type: Calendar::DEFAULT_REMINDER_TYPE,
            model_id: id
          )
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: self.id)
  end
end
