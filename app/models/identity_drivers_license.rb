class IdentityDriversLicense < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  DEFAULT_DRIVERS_LICENSE_EXPIRATION_THRESHOLD_SECONDS = 60.days

  belongs_to :parent_identity, class_name: Identity
  
  validates :identifier, presence: true

  belongs_to :identity_file, :dependent => :destroy
  accepts_nested_attributes_for :identity_file, allow_destroy: true, reject_if: :all_blank

  def display
    identifier
  end

  def self.calendar_item_display(calendar_item)
    idl = calendar_item.find_model_object
    I18n.t(
      "myplaceonline.identities.license_expiring",
      license: idl.display,
      time: Myp.time_difference_in_general_human(TimeDifference.between(User.current_user.time_now, idl.expires).in_general)
    )
  end
  
  def self.calendar_item_link(calendar_item)
    Rails.application.routes.url_helpers.send("contact_path", calendar_item.find_model_object.parent_identity.ensure_contact!)
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if !expires.nil?
      ActiveRecord::Base.transaction do
        CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: id)
        User.current_user.primary_identity.calendars.each do |calendar|
          CalendarItem.create_calendar_item(
            User.current_user.primary_identity,
            calendar,
            self.class,
            expires,
            (calendar.drivers_license_expiration_threshold_seconds || DEFAULT_DRIVERS_LICENSE_EXPIRATION_THRESHOLD_SECONDS),
            Calendar::DEFAULT_REMINDER_TYPE,
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
