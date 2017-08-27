require 'tmpdir'
require 'rubygems'
require 'zip'
require 'tempfile'
require 'fileutils'

class ShareJob < ApplicationJob
  def perform(*args)
    
    ExecutionContext.stack do

      job_context = args.shift
      import_job_context(job_context)

      Chewy.strategy(:atomic) do
        Rails.logger.debug{"Started ShareJob"}
        permission_share = args[0]
        Rails.logger.info{"ShareJob permission_share: #{permission_share.inspect}"}
        permission_share.execute_share
        Rails.logger.debug{"Finished ShareJob"}
      end
    end
  end
end
