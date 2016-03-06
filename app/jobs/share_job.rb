require 'tmpdir'
require 'rubygems'
require 'zip'
require 'tempfile'
require 'fileutils'

class ShareJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.debug{"Started ShareJob"}
    permission_share = args[0]
    permission_share.execute_share
    Rails.logger.debug{"Finished ShareJob"}
  end
end
