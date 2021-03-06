class ApplicationJob < ActiveJob::Base
  include Rails.application.routes.url_helpers
  
  queue_as :default
  
  def self.job_context
    {
      # http://edgeapi.rubyonrails.org/classes/ActiveJob/SerializationError.html
      execution_context: ExecutionContext.export.keep_if{|k,v|
        v.is_a?(NilClass) || v.is_a?(Numeric) || v.is_a?(String) || v.is_a?(TrueClass) || v.is_a?(FalseClass) || (v.is_a?(ActiveRecord::Base) && !v.id.nil?)
      }
    }
  end

  def self.perform(job_class, *args)
    context = self.job_context
    args_array = *args
    args_array = [context] + args_array 
    if Rails.env.production?
      job_class.perform_later(*args_array)
    else
      job_class.perform_now(*args_array)
    end
  end
  
  def self.perform_async(job_class, *args)
    context = self.job_context
    Rails.logger.debug{"ApplicationJob perform_async job_class: #{job_class}, args: #{args}, context: #{Myp.debug_print(context)}"}
    args_array = *args
    args_array = [context] + args_array 
    job_class.perform_later(*args_array)
  end

  def self.perform_sync(job_class, *args)
    context = self.job_context
    Rails.logger.debug{"ApplicationJob perform_sync job_class: #{job_class}, args: #{args}, context: #{Myp.debug_print(context)}"}
    args_array = *args
    args_array = [context] + args_array 
    job_class.perform_now(*args_array)
  end
  
  def perform(*args)
    ExecutionContext.stack do
      do_perform(*args)
    end
  end
  
  class ExceptionWithExecutionContexts < StandardError
    attr_accessor :user
    attr_accessor :e
    
    def initialize(e)
      @e = e
      @user = MyplaceonlineExecutionContext.user
    end
    
    def inner_exception
      return @e
    end
    
    def user
      return @user
    end
  end
  
  def throw_with_contexts(e)
    raise ExceptionWithExecutionContexts.new(e)
  end
  
  def do_perform(*args)
    raise "Abstract method requires implementation"
  end

  # http://edgeguides.rubyonrails.org/active_job_basics.html#exceptions
  rescue_from(StandardError) do |exception|
    ExecutionContext.stack do
      
      email = nil

      if exception.is_a?(ExceptionWithExecutionContexts)
        user = exception.user()
        exception = exception.inner_exception()
        
        if !user.nil?
          email = user.email
        end
      end
      
      Myp.handle_exception(exception, email, nil, "ActiveJob Failure: #{self.class.name}")
    end
  end
  
  def import_job_context(job_context)
    #Rails.logger.debug{"ApplicationJob.import_job_context job_context: #{Myp.debug_print(job_context)}"}
    ExecutionContext.import(job_context[:execution_context])
  end

  protected
    def default_url_options
      Rails.configuration.default_url_options
    end
end
