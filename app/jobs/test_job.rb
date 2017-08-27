class TestJob < ApplicationJob
  def perform(*args)
    
    ExecutionContext.stack do

      job_context = args.shift
      import_job_context(job_context)

      Chewy.strategy(:atomic) do
        Rails.logger.info{"Started TestJob arg1: #{args}; #{args[0]}"}
        Rails.logger.info{"default_url_options = #{default_url_options[:host]}, #{Rails.configuration.default_url_options[:host]}"}
        test = playlists_url
        Rails.logger.info{"test = #{test.inspect}"}
        Rails.logger.info{"Ended TestJob"}
      end
    end
  end
end
