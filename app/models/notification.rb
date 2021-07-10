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
  
  DEFAULT_EMAIL = true
  DEFAULT_SMS = true
  DEFAULT_APP = true

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
    result = DateTime.now.utc > self.updated_at + (2 ** self.count).days
    ::Rails.logger.debug{"Notification.ready_for_another? checking now: #{DateTime.now.utc}, self.updated_at: #{self.updated_at}, days: #{(2 ** self.count).days}, added: #{self.updated_at + (2 ** self.count).days}, result: #{result}"}
    return result
  end
  
  def self.try_send_notifications(
        identity,
        notification_category,
        subject,
        body_short_markdown,
        body_long_markdown,
        body_app_markdown,
        max_notifications: nil,
        exponential_backoff: false,
        data: {},
        default_email: DEFAULT_EMAIL,
        default_sms: DEFAULT_SMS,
        default_app: DEFAULT_APP
      )
    
    some_sent = false
    
    ::Rails.logger.debug{"Notification.try_send_notifications identity: #{identity}, notification_category: #{notification_category}"}
    
    if Notification.try_send_notification(
          identity,
          Notification::NOTIFICATION_TYPE_EMAIL,
          notification_category,
          subject,
          body_short_markdown,
          body_long_markdown,
          body_app_markdown,
          max_notifications: max_notifications,
          exponential_backoff: exponential_backoff,
          data: data,
          default_email: default_email,
          default_sms: default_sms,
          default_app: default_app,
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
        body_app_markdown,
        max_notifications: max_notifications,
        exponential_backoff: exponential_backoff,
        data: data,
        default_email: default_email,
        default_sms: default_sms,
        default_app: default_app,
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
        body_app_markdown,
        max_notifications: max_notifications,
        exponential_backoff: exponential_backoff,
        data: data,
        default_email: default_email,
        default_sms: default_sms,
        default_app: default_app,
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
        body_app_markdown,
        max_notifications: nil,
        exponential_backoff: false,
        data: {},
        default_email: DEFAULT_EMAIL,
        default_sms: DEFAULT_SMS,
        default_app: DEFAULT_APP
      )
      
    data.merge!({ # max 4KB
      identity: identity.id,
      notification_category: notification_category,
      subject: subject,
    })
    
    ::Rails.logger.debug{"Notification.try_send_notification identity: #{identity}, type: #{notification_type}, data: #{Myp.debug_print(data)}"}

    if NotificationPreference.can_send_notification?(
         identity,
         notification_type,
         notification_category,
         default_email: default_email,
         default_sms: default_sms,
         default_app: default_app
       )
      
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
          text = body_app_markdown
          body_app_markdown = Myp.markdown_for_plain_email(body_app_markdown)
          
          # https://docs.expo.io/versions/latest/guides/push-notifications/#message-format
          notifications = NotificationRegistration.where(user_id: identity.user_id).map do |notification_registration|
            {
              "to" => notification_registration.token,
              "body" => body_app_markdown,
              "sound" => "default",
              "badge" => 0,
              "priority" => "high",
              "data" => data,
              "content-available" => 1,
            }
          end
          
          ::Rails.logger.debug{"Notification.try_send_notification user: #{identity.user_id}"}
  
          if notifications.length > 0
            ::Rails.logger.info{"Notification.try_send_notification for identity #{identity.id}: #{Myp.debug_print(notifications)}"}
            
            if ENV["SKIP_NOTIFICATIONS"] != "true"
              client = Exponent::Push::Client.new(gzip: false)
              handler = client.send_messages(notifications)
              
              ::Rails.logger.info{"Notification.try_send_notification send_messages returned"}
              
              if !handler.nil? && !handler.errors.nil? && handler.errors.size > 0
                ::Rails.logger.info{"Notification.try_send_notification expo responses: #{Myp.debug_print(handler.errors)}"}
              end
            end
          end
          
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
        body_app_markdown,
        max_notifications: nil,
        exponential_backoff: false,
        data: {},
        default_email: DEFAULT_EMAIL,
        default_sms: DEFAULT_SMS,
        default_app: DEFAULT_APP
      )

    MyplaceonlineExecutionContext.do_full_identity_context(identity) do
        return Notification.try_send_notification(
            identity,
            notification_type,
            notification_category,
            subject,
            body_short_markdown,
            body_long_markdown,
            body_app_markdown,
            max_notifications: max_notifications,
            exponential_backoff: exponential_backoff,
            data: data,
            default_email: default_email,
            default_sms: default_sms,
            default_app: default_app,
        )
    end
  end
  
  def self.try_send_notifications_with_context(
        identity,
        notification_category,
        subject,
        body_short_markdown,
        body_long_markdown,
        body_app_markdown,
        max_notifications: nil,
        exponential_backoff: false,
        data: {},
        default_email: DEFAULT_EMAIL,
        default_sms: DEFAULT_SMS,
        default_app: DEFAULT_APP
      )
      
    MyplaceonlineExecutionContext.do_full_identity_context(identity) do
        return Notification.try_send_notifications(
            identity,
            notification_category,
            subject,
            body_short_markdown,
            body_long_markdown,
            body_app_markdown,
            max_notifications: max_notifications,
            exponential_backoff: exponential_backoff,
            data: data,
            default_email: default_email,
            default_sms: default_sms,
            default_app: default_app,
        )
    end
  end
  
  def self.reset_notifications(identity, notification_category)
    Notification.where(
      identity: identity,
      notification_category: notification_category,
    ).destroy_all
  end

  def self.reset_notifications_wildcard(identity, notification_category_prefix)
    Notification.where("identity_id = ? and notification_category like ?", identity.id, "#{notification_category_prefix}%").destroy_all
  end
end
