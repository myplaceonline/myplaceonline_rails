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
  
  def self.try_send_notification(identity, notification_type, notification_category, subject, body_short_markdown, body_long_markdown, max_notifications = nil)
    
    if NotificationPreference.can_send_notification?(identity, notification_type, notification_category)
      
      notification = Notification.where(
        identity: identity,
        notification_type: notification_type,
        notification_category: notification_category,
        notification_subject: subject,
      ).take
      
      count = 0
      if !notification.nil? && !notification.count.nil?
        count = notification.count
      end
      
      if max_notifications.nil? || count < max_notifications
        
        case notification_type
        when NOTIFICATION_TYPE_EMAIL
          text = body_long_markdown
          body_long_html = Myp.markdown_to_html(body_long_markdown)
          identity.send_email(subject, body_long_html, nil, nil, body_long_markdown, nil)
        when NOTIFICATION_TYPE_SMS
          text = body_short_markdown
          body_short_markdown = Myp.markdown_for_plain_email(body_short_markdown)
          identity.send_sms(body: body_short_markdown)
        when NOTIFICATION_TYPE_APP
          raise "TODO #{notification_type}"
        else
          raise "TODO #{notification_type}"
        end
        
        if notification.nil?
          Notification.create!(
            identity: identity,
            notification_type: notification_type,
            notification_category: notification_category,
            notification_subject: subject,
            notification_text: text,
            count: 1,
          )
        else
          notification.count = count + 1
          notification.save!
        end
        
        return true
      else
        return false
      end
    else
      return false
    end
  end
end
