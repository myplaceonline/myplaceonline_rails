require 'tmpdir'
require 'rubygems'
require 'zip'
require 'tempfile'
require 'fileutils'

class AsyncTextMessageJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.debug{"Started AsyncTextMessageJob"}
    email = args[0]
    email.send_sms
    Rails.logger.debug{"Finished AsyncTextMessageJob"}
  end
end
