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

  protected
    def default_url_options
      Rails.configuration.default_url_options
    end
end
