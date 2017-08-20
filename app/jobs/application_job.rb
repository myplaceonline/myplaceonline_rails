class ApplicationJob < ActiveJob::Base
  include Rails.application.routes.url_helpers
  
  queue_as :default

  def self.perform(job, *args)
    if Rails.env.production?
      job.perform_later(*args)
    else
      job.perform_now(*args)
    end
  end
  
  def self.perform_async(job, *args)
    job.perform_later(*args)
  end

  # http://edgeguides.rubyonrails.org/active_job_basics.html#exceptions
  rescue_from(StandardError) do |exception|
    Myp.handle_exception(exception, nil, nil, "ActiveJob Failure: #{self.class.name}")
  end

  protected
    def default_url_options
      Rails.configuration.default_url_options
    end
end
