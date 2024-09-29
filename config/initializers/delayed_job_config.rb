Delayed::Worker.logger = Rails.logger
Delayed::Worker.destroy_failed_jobs = true
#Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 1
Delayed::Worker.max_run_time = 400.hours
Delayed::Worker.read_ahead = 10
#Delayed::Worker.default_queue_name = 'default'
#Delayed::Worker.delay_jobs = !Rails.env.test?
Delayed::Worker.raise_signal_exceptions = :term
#Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))

# https://stackoverflow.com/a/32807004/11030758
# /usr/share/gems/gems/activejob-*/lib/active_job/logging.rb
ActiveSupport.on_load :active_job do
  class ActiveJob::Logging::LogSubscriber
    private def args_info(job)
      if job.arguments.any? && job.class.name != "UpdateUserPasswordJob" && job.class.name != "SwitchUserEncryptionJob"
        " with arguments: " +
          job.arguments.map { |arg| format(arg).inspect }.join(", ")
      else
        ""
      end
    end
  end
end
