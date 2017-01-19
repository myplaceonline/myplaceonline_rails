class Status < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  DEFAULT_STATUS_THRESHOLD_SECONDS = 4.hours

  FEELINGS = [
    ["myplaceonline.statuses.feeling_accomplished", 24],
    ["myplaceonline.statuses.feeling_alien", 9],
    ["myplaceonline.statuses.feeling_angry", 7],
    ["myplaceonline.statuses.feeling_anxious", 4],
    ["myplaceonline.statuses.feeling_confident", 14],
    ["myplaceonline.statuses.feeling_confused", 13],
    ["myplaceonline.statuses.feeling_crazy", 12],
    ["myplaceonline.statuses.feeling_depressed", 5],
    ["myplaceonline.statuses.feeling_excited", 6],
    ["myplaceonline.statuses.feeling_happy", 1],
    ["myplaceonline.statuses.feeling_hungry", 16],
    ["myplaceonline.statuses.feeling_injured", 17],
    ["myplaceonline.statuses.feeling_lonely", 10],
    ["myplaceonline.statuses.feeling_loving", 18],
    ["myplaceonline.statuses.feeling_meh", 3],
    ["myplaceonline.statuses.feeling_nervous", 8],
    ["myplaceonline.statuses.feeling_nothing", 22],
    ["myplaceonline.statuses.feeling_okay", 0],
    ["myplaceonline.statuses.feeling_sad", 2],
    ["myplaceonline.statuses.feeling_scared", 15],
    ["myplaceonline.statuses.feeling_shameful", 20],
    ["myplaceonline.statuses.feeling_shocked", 21],
    ["myplaceonline.statuses.feeling_sick", 19],
    ["myplaceonline.statuses.feeling_stressed", 25],
    ["myplaceonline.statuses.feeling_stupid", 23],
    ["myplaceonline.statuses.feeling_tired", 11]
  ]

  validates :status_time, presence: true
  
  def display
    Myp.display_datetime(status_time, User.current_user)
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.status_time = DateTime.now
    result
  end

  def self.last_status(identity)
    Status.where(
      identity: identity
    ).order("status_time DESC").limit(1).first
  end

  def self.calendar_item_display(calendar_item)
    I18n.t("myplaceonline.statuses.no_statuses")
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if MyplaceonlineExecutionContext.handle_updates?
      Status.reset_calendar_reminder
    end
  end
  
  def self.reset_calendar_reminder(after_expiration: false, initial: false)
    
    CalendarItem.destroy_calendar_items(
      User.current_user.primary_identity,
      Status
    )
    
    User.current_user.primary_identity.calendars.each do |calendar|
      new_time = User.current_user.time_now
      if !after_expiration
        new_time += 1.day
      end
      new_time = User.current_user.in_time_zone(new_time.to_date, end_of_day: true) + 1.second
      new_time -= (calendar.status_threshold_seconds || DEFAULT_STATUS_THRESHOLD_SECONDS).seconds
      if initial
        # We make the reminder for yesterday so that it shows up on the first page load
        new_time -= 1.days
      end
      
      Rails.logger.debug{"Creating status reminder for #{new_time}"}

      CalendarItem.create_calendar_item(
        identity: User.current_user.primary_identity,
        calendar: calendar,
        model: Status,
        calendar_item_time: new_time,
        reminder_threshold_amount: 0,
        reminder_threshold_type: Myp::TIME_DURATION_SECONDS,
        expire_amount: 1.day.seconds
      )
    end
  end
  
  def self.handle_expired_reminder
    Status.reset_calendar_reminder(after_expiration: true)
  end
  
  def self.create_first_status
    Rails.logger.debug{"Creating initial status"}
    Status.reset_calendar_reminder(after_expiration: true, initial: true)
    CalendarItemReminder.ensure_pending(User.current_user)
  end
  
  def show_highly_visited?
    false
  end
end
