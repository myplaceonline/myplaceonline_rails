require 'tmpdir'
require 'rubygems'
require 'zip'
require 'tempfile'
require 'fileutils'

class AsyncTextMessageJob < ApplicationJob
  def perform(*args)
    Chewy.strategy(:atomic) do
      Rails.logger.debug{"Started AsyncTextMessageJob"}
      text_message = args[0]
      text_message.send_sms
      Rails.logger.debug{"Finished AsyncTextMessageJob"}
    end
  end
end
