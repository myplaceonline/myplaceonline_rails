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
  
  def ready_for_another?
    # Exponential backoff of notifications
    return DateTime.now.utc > self.updated_at + (2 ** self.count).days
  end
  
  def self.try_send_notifications(
        identity,
        notification_category,
        subject,
        body_short_markdown,
        body_long_markdown,
        max_notifications: nil,
        exponential_backoff: false
      )
    
    some_sent = false
    
    ::Rails.logger.debug{"Notification.try_send_notifications identity: #{identity}"}
    
    if Notification.try_send_notification(
          identity,
          Notification::NOTIFICATION_TYPE_EMAIL,
          notification_category,
          subject,
          body_short_markdown,
          body_long_markdown,
          max_notifications: max_notifications,
          exponential_backoff: exponential_backoff
        )
      some_sent = true
    end

    if Notification.try_send_notification(
        identity,
        Notification::NOTIFICATION_TYPE_SMS,
        notification_category,
        subject,
        body_short_markdown,
        body_long_markdown,
        max_notifications: max_notifications,
        exponential_backoff: exponential_backoff
      )
      some_sent = true
    end

    if Notification.try_send_notification(
        identity,
        Notification::NOTIFICATION_TYPE_APP,
        notification_category,
        subject,
        body_short_markdown,
        body_long_markdown,
        max_notifications: max_notifications,
        exponential_backoff: exponential_backoff
      )
      some_sent = true
    end

    ::Rails.logger.debug{"Notification.try_send_notifications some_sent: #{some_sent}"}

    return some_sent
  end
  
  def self.try_send_notification(
        identity,
        notification_type,
        notification_category,
        subject,
        body_short_markdown,
        body_long_markdown,
        max_notifications: nil,
        exponential_backoff: false
      )
    
    ::Rails.logger.debug{"Notification.try_send_notification identity: #{identity}, type: #{notification_type}"}

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
      
      ::Rails.logger.debug{"Notification.try_send_notification count: #{count}"}

      send_notification = (max_notifications.nil? || count < max_notifications)
      
      if send_notification && exponential_backoff && !notification.nil?
        if !notification.ready_for_another?
          ::Rails.logger.debug{"Notification.try_send_notification not ready for another"}
          send_notification = false
        end
      end
      
      if send_notification
        
        case notification_type
        when NOTIFICATION_TYPE_EMAIL
          text = body_long_markdown
          body_long_html = Myp.markdown_to_html(body_long_markdown)
          ::Rails.logger.debug{"Notification.try_send_notification sending email"}
          identity.send_email(subject, body_long_html, nil, nil, body_long_markdown, nil)
        when NOTIFICATION_TYPE_SMS
          text = body_short_markdown
          body_short_markdown = Myp.markdown_for_plain_email(body_short_markdown)
          ::Rails.logger.debug{"Notification.try_send_notification sending sms"}
          identity.send_sms(body: body_short_markdown)
        when NOTIFICATION_TYPE_APP
          text = body_short_markdown
          body_short_markdown = Myp.markdown_for_plain_email(body_short_markdown)
          ::Rails.logger.debug{"Notification.try_send_notification sending app"}
        else
          raise "TODO #{notification_type}"
        end
        
        if notification.nil?
          ::Rails.logger.debug{"Notification.try_send_notification creating new notification"}
          
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
  
  def self.try_send_notification_with_context(
        identity,
        notification_type,
        notification_category,
        subject,
        body_short_markdown,
        body_long_markdown,
        max_notifications: nil,
        exponential_backoff: false
      )
    MyplaceonlineExecutionContext.do_permission_target(identity) do
      MyplaceonlineExecutionContext.do_allow_cross_identity(identity) do
        return Notification.try_send_notification(
                identity,
                notification_type,
                notification_category,
                subject,
                body_short_markdown,
                body_long_markdown,
                max_notifications: max_notifications,
                exponential_backoff: exponential_backoff
              )
      end
    end
  end
  
  def self.try_send_notifications_with_context(
        identity,
        notification_category,
        subject,
        body_short_markdown,
        body_long_markdown,
        max_notifications: nil,
        exponential_backoff: false
      )
    MyplaceonlineExecutionContext.do_permission_target(identity) do
      MyplaceonlineExecutionContext.do_allow_cross_identity(identity) do
        return Notification.try_send_notifications(
                identity,
                notification_category,
                subject,
                body_short_markdown,
                body_long_markdown,
                max_notifications: max_notifications,
                exponential_backoff: exponential_backoff
              )
      end
    end
  end
end
