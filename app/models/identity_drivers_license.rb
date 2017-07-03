class IdentityDriversLicense < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  DEFAULT_DRIVERS_LICENSE_EXPIRATION_THRESHOLD_SECONDS = 60.days

  belongs_to :parent_identity, class_name: "Identity"
  
  validates :identifier, presence: true

  child_property(name: :identity_file)

  def display
    identifier
  end

  def self.calendar_item_display(calendar_item)
    idl = calendar_item.find_model_object
    I18n.t(
      "myplaceonline.identities.license_expiring",
      license: idl.display,
      time: Myp.time_delta(idl.expires)
    )
  end
  
  def self.calendar_item_link(calendar_item)
    Rails.application.routes.url_helpers.send("contact_path", calendar_item.find_model_object.parent_identity.ensure_contact!)
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if MyplaceonlineExecutionContext.handle_updates?
      if !expires.nil?
        ApplicationRecord.transaction do
          CalendarItem.destroy_calendar_items(User.current_user.current_identity, self.class, model_id: id)
          User.current_user.current_identity.calendars.each do |calendar|
            CalendarItem.create_calendar_item(
              identity: User.current_user.current_identity,
              calendar: calendar,
              model: self.class,
              calendar_item_time: expires,
              reminder_threshold_amount: (calendar.drivers_license_expiration_threshold_seconds || DEFAULT_DRIVERS_LICENSE_EXPIRATION_THRESHOLD_SECONDS),
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
end
