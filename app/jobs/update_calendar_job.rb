class UpdateCalendarJob < ApplicationJob
  def perform(*args)
    
    ExecutionContext.stack do

      job_context = args.shift
      import_job_context(job_context)

      Chewy.strategy(:atomic) do
        Rails.logger.debug{"Started UpdateCalendarJob"}
        user = args[0]
        MyplaceonlineExecutionContext.do_user(user) do
          CalendarItemReminder.ensure_pending(user)
        end
        Rails.logger.debug{"Finished UpdateCalendarJob"}
      end
    end
  end
end
