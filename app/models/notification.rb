class Notification < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :notification_subject, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notification_text, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notification_type, type: ApplicationRecord::PROPERTY_TYPE_SELECT },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

  NOTIFICATION_TYPE_EMAIL = 0
  NOTIFICATION_TYPE_SMS = 1
  NOTIFICATION_TYPE_APP = 2

  NOTIFICATION_TYPES = [
    ["myplaceonline.notifications.notification_types.email", NOTIFICATION_TYPE_EMAIL],
    ["myplaceonline.notifications.notification_types.sms", NOTIFICATION_TYPE_SMS],
    ["myplaceonline.notifications.notification_types.app", NOTIFICATION_TYPE_APP],
  ]

  validates :notification_subject, presence: true
  validates :notification_text, presence: true
  validates :notification_type, presence: true
  
  def display
    self.notification_subject
  end
end
