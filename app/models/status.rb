class Status < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  DEFAULT_STATUS_THRESHOLD_SECONDS = 16.hours

  FEELINGS = [
    ["myplaceonline.statuses.feeling_okay", 0],
    ["myplaceonline.statuses.feeling_happy", 1],
    ["myplaceonline.statuses.feeling_sad", 2],
    ["myplaceonline.statuses.feeling_meh", 3],
    ["myplaceonline.statuses.feeling_anxious", 4],
    ["myplaceonline.statuses.feeling_depressed", 5],
    ["myplaceonline.statuses.feeling_excited", 6],
    ["myplaceonline.statuses.feeling_angry", 7],
    ["myplaceonline.statuses.feeling_nervous", 8],
    ["myplaceonline.statuses.feeling_alien", 9],
    ["myplaceonline.statuses.feeling_lonely", 10],
    ["myplaceonline.statuses.feeling_tired", 11],
    ["myplaceonline.statuses.feeling_crazy", 12],
    ["myplaceonline.statuses.feeling_confused", 13],
    ["myplaceonline.statuses.feeling_confident", 14],
    ["myplaceonline.statuses.feeling_scared", 15],
    ["myplaceonline.statuses.feeling_hungry", 16],
    ["myplaceonline.statuses.feeling_injured", 17],
    ["myplaceonline.statuses.feeling_loving", 18],
    ["myplaceonline.statuses.feeling_sick", 19],
    ["myplaceonline.statuses.feeling_shameful", 20],
    ["myplaceonline.statuses.feeling_shocked", 21],
    ["myplaceonline.statuses.feeling_nothing", 22],
    ["myplaceonline.statuses.feeling_stupid", 23]
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
    ).order('status_time DESC').limit(1).first
  end

  def self.calendar_item_display(calendar_item)
    if calendar_item.calendar_item_time.nil?
      I18n.t("myplaceonline.statuses.no_statuses")
    else
      I18n.t(
        "myplaceonline.statuses.no_recent_status",
        delta: Myp.time_delta(calendar_item.calendar_item_time)
      )
    end
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    last_status = Status.last_status(
      User.current_user.primary_identity
    )

    if !last_status.nil?
      ActiveRecord::Base.transaction do
        CalendarItem.destroy_calendar_items(
          User.current_user.primary_identity,
          Status
        )

        User.current_user.primary_identity.calendars.each do |calendar|
          CalendarItem.create_calendar_item(
            User.current_user.primary_identity,
            calendar,
            Status,
            last_status.status_time + (calendar.status_threshold_seconds || DEFAULT_STATUS_THRESHOLD_SECONDS).seconds,
            15.minutes.seconds.to_i,
            Myp::REPEAT_TYPE_SECONDS
          )
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    on_after_save

    last_status = Status.last_status(
      User.current_user.primary_identity
    )
    
    if last_status.nil?
      User.current_user.primary_identity.calendars.each do |calendar|
        CalendarItem.ensure_persistent_calendar_item(
          User.current_user.primary_identity,
          calendar,
          Status
        )
      end
    end
  end
end
