require 'tmpdir'
require 'rubygems'
require 'zip'
require 'tempfile'
require 'fileutils'

class AsyncEmailJob < ApplicationJob
  def do_perform(*args)
    
    ExecutionContext.stack do

      job_context = args.shift
      import_job_context(job_context)

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
end
