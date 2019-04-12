require 'tmpdir'
require 'rubygems'
require 'zip'
require 'tempfile'
require 'fileutils'

class AsyncTextMessageJob < ApplicationJob
  def do_perform(*args)
    
    ExecutionContext.stack do

      job_context = args.shift
      import_job_context(job_context)

      Chewy.strategy(:atomic) do
        Rails.logger.debug{"Started AsyncTextMessageJob"}
        text_message = args[0]
        MyplaceonlineExecutionContext.do_identity(text_message.identity) do
          text_message.send_sms
        end
        Rails.logger.debug{"Finished AsyncTextMessageJob"}
      end
    end
  end
end
