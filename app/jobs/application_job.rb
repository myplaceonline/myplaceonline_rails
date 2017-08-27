class ApplicationJob < ActiveJob::Base
  include Rails.application.routes.url_helpers
  
  queue_as :default
  
  def self.job_context
    {
      execution_context: ExecutionContext.export
    }
  end

  def self.perform(job_class, *args)
    context = self.job_context
    args_array = *args
    args_array = [context] + args_array 
    if Rails.env.production?
      job_class.perform_later(*args_array)
    else
      job_class.perform_now(*args_array)
    end
  end
  
  def self.perform_async(job_class, *args)
    context = self.job_context
    args_array = *args
    args_array = [context] + args_array 
    job_class.perform_later(*args_array)
  end

  # http://edgeguides.rubyonrails.org/active_job_basics.html#exceptions
  rescue_from(StandardError) do |exception|
    Myp.handle_exception(exception, nil, nil, "ActiveJob Failure: #{self.class.name}")
  end
  
  def import_job_context(job_context)
    #Rails.logger.debug{"ApplicationJob.import_job_context job_context: #{Myp.debug_print(job_context)}"}
    ExecutionContext.import(job_context[:execution_context])
  end

  protected
    def default_url_options
      Rails.configuration.default_url_options
    end
end
