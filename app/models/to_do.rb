class ToDo < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  DEFAULT_TODO_THRESHOLD_SECONDS = 7.days

  validates :short_description, presence: true
  
  def display
    short_description
  end
  
  def self.calendar_item_display(calendar_item)
    to_do = calendar_item.find_model_object
    I18n.t(
      "myplaceonline.to_dos.upcoming",
      name: to_do.display,
      delta: Myp.time_delta(to_do.due_time)
    )
  end

  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if !due_time.nil?
      ActiveRecord::Base.transaction do
        CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: id)
        User.current_user.primary_identity.calendars.each do |calendar|
          CalendarItem.create_calendar_item(
            User.current_user.primary_identity,
            calendar,
            self.class,
            due_time,
            (calendar.todo_threshold_seconds || DEFAULT_TODO_THRESHOLD_SECONDS),
            Calendar::DEFAULT_REMINDER_TYPE,
            model_id: id
          )
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: self.id)
  end
end
