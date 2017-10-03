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
  THRESHOLD_TYPE_TIME_BEFORE_D = 4
  THRESHOLD_TYPE_TIME_BEFORE_W = 5
  THRESHOLD_TYPE_TIME_BEFORE_MO = 6
  THRESHOLD_TYPE_TIME_BEFORE_Y = 7

  THRESHOLD_TYPES = [
    ["myplaceonline.reminders.reminder_threshold_types.immediate", THRESHOLD_TYPE_IMMEDIATE],
    ["myplaceonline.reminders.reminder_threshold_types.time_before_s", THRESHOLD_TYPE_TIME_BEFORE_S],
    ["myplaceonline.reminders.reminder_threshold_types.time_before_m", THRESHOLD_TYPE_TIME_BEFORE_M],
    ["myplaceonline.reminders.reminder_threshold_types.time_before_h", THRESHOLD_TYPE_TIME_BEFORE_H],
    ["myplaceonline.reminders.reminder_threshold_types.time_before_d", THRESHOLD_TYPE_TIME_BEFORE_D],
    ["myplaceonline.reminders.reminder_threshold_types.time_before_w", THRESHOLD_TYPE_TIME_BEFORE_W],
    ["myplaceonline.reminders.reminder_threshold_types.time_before_mo", THRESHOLD_TYPE_TIME_BEFORE_MO],
    ["myplaceonline.reminders.reminder_threshold_types.time_before_y", THRESHOLD_TYPE_TIME_BEFORE_Y],
  ]
  
  EXPIRATION_TYPES = [
    ["myplaceonline.reminders.expire_types.time_after_s", Myp::TIME_DURATION_SECONDS],
    ["myplaceonline.reminders.expire_types.time_after_m", Myp::TIME_DURATION_MINUTES],
    ["myplaceonline.reminders.expire_types.time_after_h", Myp::TIME_DURATION_HOURS],
    ["myplaceonline.reminders.expire_types.time_after_d", Myp::TIME_DURATION_DAYS],
    ["myplaceonline.reminders.expire_types.time_after_w", Myp::TIME_DURATION_WEEKS],
    ["myplaceonline.reminders.expire_types.time_after_mo", Myp::TIME_DURATION_MONTHS],
    ["myplaceonline.reminders.expire_types.time_after_y", Myp::TIME_DURATION_YEARS],
  ]
  
  REPEAT_TYPE_ONCE_PER_WEEK = -1
  REPEAT_TYPE_TWICE_PER_WEEK = -2
  
  REPEAT_TYPES = [
    ["myplaceonline.reminders.repeat_types.time_after_1pw", REPEAT_TYPE_ONCE_PER_WEEK],
    ["myplaceonline.reminders.repeat_types.time_after_2pw", REPEAT_TYPE_TWICE_PER_WEEK],
    ["myplaceonline.reminders.repeat_types.time_after_s", Myp::TIME_DURATION_SECONDS],
    ["myplaceonline.reminders.repeat_types.time_after_m", Myp::TIME_DURATION_MINUTES],
    ["myplaceonline.reminders.repeat_types.time_after_h", Myp::TIME_DURATION_HOURS],
    ["myplaceonline.reminders.repeat_types.time_after_d", Myp::TIME_DURATION_DAYS],
    ["myplaceonline.reminders.repeat_types.time_after_w", Myp::TIME_DURATION_WEEKS],
    ["myplaceonline.reminders.repeat_types.time_after_mo", Myp::TIME_DURATION_MONTHS],
    ["myplaceonline.reminders.repeat_types.time_after_y", Myp::TIME_DURATION_YEARS],
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
      when THRESHOLD_TYPE_IMMEDIATE, nil
        rtt = Myp::TIME_DURATION_SECONDS
        rta = 0
      when THRESHOLD_TYPE_TIME_BEFORE_S
        rtt = Myp::TIME_DURATION_SECONDS
      when THRESHOLD_TYPE_TIME_BEFORE_M
        rtt = Myp::TIME_DURATION_MINUTES
      when THRESHOLD_TYPE_TIME_BEFORE_H
        rtt = Myp::TIME_DURATION_HOURS
      when THRESHOLD_TYPE_TIME_BEFORE_D
        rtt = Myp::TIME_DURATION_DAYS
      when THRESHOLD_TYPE_TIME_BEFORE_W
        rtt = Myp::TIME_DURATION_WEEKS
      when THRESHOLD_TYPE_TIME_BEFORE_MO
        rtt = Myp::TIME_DURATION_MONTHS
      when THRESHOLD_TYPE_TIME_BEFORE_Y
        rtt = Myp::TIME_DURATION_YEARS
      else
        raise "TODO"
      end
      
      rt = self.repeat_type
      ra = self.repeat_amount
      
      case self.repeat_type
      when REPEAT_TYPE_ONCE_PER_WEEK
        rt = Myp::TIME_DURATION_WEEKS
        ra = 1
      when REPEAT_TYPE_TWICE_PER_WEEK
        rt = Myp::TIME_DURATION_DAYS
        ra = 3
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
        repeat_amount: ra,
        repeat_type: rt,
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
