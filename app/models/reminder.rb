class Reminder < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :reminder_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :start_time, type: ApplicationRecord::PROPERTY_TYPE_DATETIME },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :reminder_threshold_amount, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
      { name: :reminder_threshold_type, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
      { name: :expire_amount, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
      { name: :expire_type, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
      { name: :repeat_amount, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
      { name: :repeat_type, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
      { name: :max_pending, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
    ]
  end

  THRESHOLD_TYPE_IMMEDIATE = 0
  THRESHOLD_TYPE_TIME_BEFORE = 1

  THRESHOLD_TYPES = [
    ["myplaceonline.reminders.reminder_threshold_types.immediate", THRESHOLD_TYPE_IMMEDIATE],
    ["myplaceonline.reminders.reminder_threshold_types.time_before", THRESHOLD_TYPE_TIME_BEFORE],
  ]

  validates :start_time, presence: true
  validates :reminder_name, presence: true
  
  def display
    reminder_name
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.start_time = User.current_user.time_now
    result
  end
end
