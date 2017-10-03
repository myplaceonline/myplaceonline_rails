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
  THRESHOLD_TYPE_TIME_BEFORE_S = 1
  THRESHOLD_TYPE_TIME_BEFORE_M = 2
  THRESHOLD_TYPE_TIME_BEFORE_H = 3

  THRESHOLD_TYPES = [
    ["myplaceonline.reminders.reminder_threshold_types.immediate", THRESHOLD_TYPE_IMMEDIATE],
    ["myplaceonline.reminders.reminder_threshold_types.time_before_s", THRESHOLD_TYPE_TIME_BEFORE_S],
    ["myplaceonline.reminders.reminder_threshold_types.time_before_m", THRESHOLD_TYPE_TIME_BEFORE_M],
    ["myplaceonline.reminders.reminder_threshold_types.time_before_h", THRESHOLD_TYPE_TIME_BEFORE_H],
  ]
  
  EXPIRATION_TYPES = [
    ["myplaceonline.reminders.expire_types.time_after_s", Myp::TIME_DURATION_SECONDS],
    ["myplaceonline.reminders.expire_types.time_after_m", Myp::TIME_DURATION_MINUTES],
    ["myplaceonline.reminders.expire_types.time_after_h", Myp::TIME_DURATION_HOURS],
  ]
  
  REPEAT_TYPES = [
    ["myplaceonline.reminders.repeat_types.time_after_s", Myp::TIME_DURATION_SECONDS],
    ["myplaceonline.reminders.repeat_types.time_after_m", Myp::TIME_DURATION_MINUTES],
    ["myplaceonline.reminders.repeat_types.time_after_h", Myp::TIME_DURATION_HOURS],
  ]
  
  attr_accessor :is_saving
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if !self.is_saving
      
      Rails.logger.debug{"Reminder.on_after_save #{self.id}"}
      
      self.is_saving = true
      
      if !self.calendar_item.nil?
        c = self.calendar_item
        self.calendar_item = nil
        self.save!
        
        c.destroy!
      end

      rta = self.reminder_threshold_amount
      
      case self.reminder_threshold_type
      when THRESHOLD_TYPE_IMMEDIATE
        rtt = Myp::TIME_DURATION_SECONDS
        rta = 0
      when THRESHOLD_TYPE_TIME_BEFORE_S
        rtt = Myp::TIME_DURATION_SECONDS
      when THRESHOLD_TYPE_TIME_BEFORE_M
        rtt = Myp::TIME_DURATION_MINUTES
      when THRESHOLD_TYPE_TIME_BEFORE_H
        rtt = Myp::TIME_DURATION_HOURS
      else
        raise "TODO"
      end
      
      self.calendar_item = CalendarItem.create_calendar_item(
        identity: self.identity,
        calendar: self.identity.main_calendar,
        model: self.class,
        calendar_item_time: self.start_time,
        reminder_threshold_amount: rta,
        reminder_threshold_type: rtt,
        model_id: self.id,
        expire_amount: self.expire_amount,
        expire_type: self.expire_type,
        repeat_amount: self.repeat_amount,
        repeat_type: self.repeat_type,
        max_pending: self.max_pending,
      )
      
      self.save!
    end
  end
  
  def self.calendar_item_display(calendar_item)
    reminder = calendar_item.find_model_object
    reminder.reminder_name
  end
  
  child_property(name: :calendar_item, destroy_dependent: true)

  validates :start_time, presence: true
  validates :reminder_name, presence: true
  
  def display
    reminder_name
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    #result.start_time = User.current_user.time_now
    #result.reminder_threshold_type = THRESHOLD_TYPE_IMMEDIATE
    result
  end
end
