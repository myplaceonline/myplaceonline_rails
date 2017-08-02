require 'tmpdir'
require 'rubygems'
require 'zip'
require 'tempfile'
require 'fileutils'

class AsyncEmailJob < ApplicationJob
  def perform(*args)
    Chewy.strategy(:atomic) do
      Rails.logger.debug{"Started AsyncEmailJob"}
      email = args[0]
      Rails.logger.info{"AsyncEmailJob Processing #{email.inspect}"}
      MyplaceonlineExecutionContext.do_identity(email.identity) do
        email.send_email
      end
      Rails.logger.debug{"Finished AsyncEmailJob"}
    end
  end
end
