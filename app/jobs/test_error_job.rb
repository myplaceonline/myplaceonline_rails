class TestErrorJob < ApplicationJob
  def do_perform(*args)
    
    ExecutionContext.stack do

      job_context = args.shift
      import_job_context(job_context)

      Chewy.strategy(:atomic) do
        Rails.logger.info{"Started TestErrorJob"}
        raise "TestErrorJob Exception"
        Rails.logger.info{"Ended TestJob"}
      end
    end
  end
end
