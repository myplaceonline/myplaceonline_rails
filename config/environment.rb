# Load the Rails application.
require_relative 'application'

if !ENV["MEMPROFILE"].blank?
  
  # This profiles all initializers including engines

  require 'memory_profiler'
  MemoryProfiler.start
end

# Initialize the Rails application.
Rails.application.initialize!

if !ENV["MEMPROFILE"].blank?
  puts "MEMPROFILE: config/environment"
  report = MemoryProfiler.stop
  report.pretty_print
end
