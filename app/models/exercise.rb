class Exercise < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  DEFAULT_EXERCISE_THRESHOLD_SECONDS = 3.days
  
  validates :exercise_start, presence: true
  
  def display
    Myp.display_datetime(exercise_start, User.current_user)
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.exercise_start = DateTime.now
    result
  end

  def self.last_exercise(identity)
    Exercise.where(
      identity: identity
    ).order('exercise_start DESC').limit(1).first
  end

  def self.calendar_item_display(calendar_item)
    I18n.t(
      "myplaceonline.exercises.last_exercise",
      delta: Myp.time_delta(calendar_item.calendar_item_time)
    )
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if MyplaceonlineExecutionContext.handle_updates?
      last_exercise = Exercise.last_exercise(
        User.current_user.primary_identity,
      )

      if !last_exercise.nil?
        ApplicationRecord.transaction do
          CalendarItem.destroy_calendar_items(
            User.current_user.primary_identity,
            Exercise
          )

          User.current_user.primary_identity.calendars.each do |calendar|
            CalendarItem.create_calendar_item(
              identity: User.current_user.primary_identity,
              calendar: calendar,
              model: Exercise,
              calendar_item_time: last_exercise.exercise_start + (calendar.exercise_threshold_seconds || DEFAULT_EXERCISE_THRESHOLD_SECONDS).seconds,
              reminder_threshold_amount: 1.hours,
              reminder_threshold_type: Calendar::DEFAULT_REMINDER_TYPE
            )
          end
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    last_exercise = Exercise.last_exercise(
      User.current_user.primary_identity,
    )
    
    if last_exercise.nil?
      CalendarItem.destroy_calendar_items(
        User.current_user.primary_identity,
        Exercise
      )
    else
      on_after_save
    end
  end
end
