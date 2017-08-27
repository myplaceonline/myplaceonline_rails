class AdminExecuteCommandJob < ApplicationJob
  def perform(*args)
    
    ExecutionContext.stack do

      job_context = args.shift
      import_job_context(job_context)

      Chewy.strategy(:atomic) do
        Rails.logger.info{"Started AdminExecuteCommandJob"}
        
        command = args[0]

        Rails.logger.info{"Command: #{command}"}
        
        execute_command(command)
        
        Rails.logger.info{"Ended AdminExecuteCommandJob"}
      end
    end
  end

  def execute_command(cmd)
    result = ""
    Rails.logger.info{"Executing: #{cmd}"}
    Open3.popen2e(cmd) do |stdin, stdout_and_stderr, wait_thr|
      result = stdout_and_stderr.read
      exit_status = wait_thr.value
      if exit_status != 0
        raise "Exit status " + exit_status.to_s + ": #{result}"
      end
    end
    Rails.logger.info{"Result:\n#{result}"}
    result
  end
end
