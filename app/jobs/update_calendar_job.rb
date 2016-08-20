class UpdateCalendarJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.debug{"Started UpdateCalendarJob"}
    user = args[0]
    begin
      User.current_user = user
      CalendarItemReminder.ensure_pending(user)
    ensure
      User.current_user = nil
    end
    Rails.logger.debug{"Finished UpdateCalendarJob"}
  end
end
