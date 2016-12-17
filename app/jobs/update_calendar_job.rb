class UpdateCalendarJob < ApplicationJob
  def perform(*args)
    Chewy.strategy(:atomic) do
      Rails.logger.debug{"Started UpdateCalendarJob"}
      user = args[0]
      ExecutionContext.stack do
        User.current_user = user
        CalendarItemReminder.ensure_pending(user)
      end
      Rails.logger.debug{"Finished UpdateCalendarJob"}
    end
  end
end
