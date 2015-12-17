class ApplicationJob < ActiveJob::Base
  include Rails.application.routes.url_helpers

  protected
  def default_url_options
    Rails.application.config.default_url_options
  end
end
