require 'tmpdir'
require 'rubygems'
require 'zip'
require 'tempfile'
require 'fileutils'

class AsyncEmailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.debug{"Started AsyncEmailJob"}
    email = args[0]
    Rails.logger.info{"AsyncEmailJob Processing #{email.inspect}"}
    email.send_email
    Rails.logger.debug{"Finished AsyncEmailJob"}
  end
end
