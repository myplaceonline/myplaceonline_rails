class Reminder < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :reminder_datetime, type: ApplicationRecord::PROPERTY_TYPE_DATETIME },
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

  validates :start_time, presence: true
  
  def display
    Myp.display_datetime_short_year(start_time, User.current_user)
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.start_time = User.current_user.time_now
    result
  end
end
