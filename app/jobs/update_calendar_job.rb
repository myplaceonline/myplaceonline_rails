class UpdateCalendarJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.debug{"Started UpdateCalendarJob"}
    user = args[0]
    begin
      ExecutionContext.push
      User.current_user = user
      CalendarItemReminder.ensure_pending(user)
    ensure
      ExecutionContext.clear
    end
    Rails.logger.debug{"Finished UpdateCalendarJob"}
  end
end
