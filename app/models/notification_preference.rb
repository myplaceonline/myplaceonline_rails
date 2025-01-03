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
  
  def self.can_send_notification?(
        identity,
        notification_type,
        notification_category,
        default_email: Notification::DEFAULT_EMAIL,
        default_sms: Notification::DEFAULT_SMS,
        default_app: Notification::DEFAULT_APP
  )
    preference = NotificationPreference.where(identity: identity, notification_type: notification_type, notification_category: notification_category).take
    
    result = true
    
    if preference.nil?
      case notification_type
      when Notification::NOTIFICATION_TYPE_EMAIL
        result = default_email
      when Notification::NOTIFICATION_TYPE_SMS
        result = default_sms
      when Notification::NOTIFICATION_TYPE_APP
        result = default_app
      else
        raise "TODO #{notification_type}"
      end
    else
      result = preference.notifications_enabled?
    end
    
    ::Rails.logger.debug{"NotificationPreference.can_send_notification? identity: #{identity}, notification_type: #{notification_type}, preference: #{preference}, result: #{result}"}
    return result
  end
  
  def self.update_settings(identity, settings)
    ActiveRecord::Base.transaction do
      settings.each do |notification_category, settings_by_type|
        settings_by_type.each do |notification_type, notifications_enabled|
          preference = NotificationPreference.where(
            identity: identity,
            notification_type: notification_type.to_i,
            notification_category: notification_category,
          ).take
          
          if preference.nil?
            NotificationPreference.create!(
              identity: identity,
              notification_type: notification_type.to_i,
              notification_category: notification_category,
              notifications_enabled: notifications_enabled,
            )
          else
            preference.notifications_enabled = notifications_enabled
            preference.save!
          end
        end
      end
    end
  end
  
  def self.searchable?
    return false
  end
end
