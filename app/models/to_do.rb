class ToDo < ApplicationRecord
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
    if MyplaceonlineExecutionContext.handle_updates?
      if !due_time.nil?
        ApplicationRecord.transaction do
          CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: id)
          User.current_user.primary_identity.calendars.each do |calendar|
            CalendarItem.create_calendar_item(
              identity: User.current_user.primary_identity,
              calendar: calendar,
              model: self.class,
              calendar_item_time: due_time,
              reminder_threshold_amount: (calendar.todo_threshold_seconds || DEFAULT_TODO_THRESHOLD_SECONDS),
              reminder_threshold_type: Calendar::DEFAULT_REMINDER_TYPE,
              model_id: id
            )
          end
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: self.id)
  end
end
