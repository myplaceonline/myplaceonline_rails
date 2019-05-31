class Setting < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :setting_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :setting_value, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :category, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  validates :setting_name, presence: true
  
  def display
    "#{self.setting_name}=#{self.setting_value}"
  end

  child_property(name: :category)
  
  def self.get_setting(category:, name:)
    Setting.where(
      identity_id: User.current_user.current_identity_id,
      setting_name: name,
      category: category
    ).take
  end
  
  def self.get_value(category:, name:, default_value: nil)
    setting = self.get_setting(category: category, name: name)
    if setting.nil?
      default_value
    else
      setting.setting_value
    end
  end
  
  def self.get_value_boolean(category:, name:, default_value: false)
    result = self.get_value(category: category, name: name, default_value: default_value.to_s)
    result.nil? ? default_value : result.to_bool
  end
  
  def self.get_value_integer(category:, name:, default_value: -1)
    result = self.get_value(category: category, name: name, default_value: default_value.to_s)
    result.nil? ? default_value : result.to_i
  end
  
  def self.set_value(category:, name:, value:)
    setting = self.get_setting(category: category, name: name)
    if setting.nil?
      Setting.create!(
        identity_id: User.current_user.current_identity_id,
        setting_name: name,
        category: category,
        setting_value: value
      )
    else
      setting.setting_value = value
      setting.save!
    end
  end
end
