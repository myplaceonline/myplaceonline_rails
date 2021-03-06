class HappyThing < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  DEFAULT_HAPPY_THINGS_THRESHOLD = 15.days

  validates :happy_thing_name, presence: true
  
  def display
    happy_thing_name
  end

  def self.calendar_item_display(calendar_item)
    happy_thing = calendar_item.find_model_object
    I18n.t(
      "myplaceonline.happy_things.reminder",
      name: happy_thing.display,
      delta: Myp.time_delta(calendar_item.calendar_item_time)
    )
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if MyplaceonlineExecutionContext.handle_updates?
      ApplicationRecord.transaction do
        on_after_destroy
        User.current_user.current_identity.calendars.each do |calendar|
          CalendarItem.create_calendar_item(
            identity: User.current_user.current_identity,
            calendar: calendar,
            model: self.class,
            calendar_item_time: User.current_user.time_now + (calendar.happy_things_threshold_seconds || DEFAULT_HAPPY_THINGS_THRESHOLD).seconds,
            reminder_threshold_amount: Calendar::DEFAULT_REMINDER_AMOUNT,
            reminder_threshold_type: Calendar::DEFAULT_REMINDER_TYPE,
            model_id: id,
            repeat_amount: (calendar.happy_things_threshold_seconds || DEFAULT_HAPPY_THINGS_THRESHOLD).seconds,
            repeat_type: Myp::TIME_DURATION_SECONDS,
            max_pending: 1
          )
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(
      User.current_user.current_identity,
      self.class,
      model_id: id
    )
  end
end
