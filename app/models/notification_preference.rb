class NotificationPreference < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :notification_type, type: ApplicationRecord::PROPERTY_TYPE_SELECT },
      { name: :notification_category, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notifications_enabled, type: ApplicationRecord::PROPERTY_TYPE_BOOLEAN },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

  validates :notification_type, presence: true
  
  def display
    Myp.appendstrwrap(Myp.get_select_name(self.notification_type, Notification::NOTIFICATION_TYPES), self.notification_category)
  end
  
  def self.can_send_notification?(identity, notification_type, notification_category)
    preference = NotificationPreference.where(identity: identity, notification_type: notification_type, notification_category: notification_category).take
    return preference.nil? || preference.notifications_enabled?
  end
end
