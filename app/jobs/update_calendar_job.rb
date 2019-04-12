class UpdateCalendarJob < ApplicationJob
  def do_perform(*args)
    
    ExecutionContext.stack do

      job_context = args.shift
      import_job_context(job_context)

      Chewy.strategy(:atomic) do
        Rails.logger.debug{"Started UpdateCalendarJob"}
        user = args[0]
        CalendarItemReminder.ensure_pending(user)
        Rails.logger.debug{"Finished UpdateCalendarJob"}
      end
    end
  end
end
