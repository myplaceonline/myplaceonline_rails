class Timing < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :timing_name, presence: true
  
  child_properties(name: :timing_events)

  def display
    timing_name
  end
  
  def ready_timing_events
    timing_events.to_a.dup.keep_if{|x| x.ready?}
  end
  
  def minimum_duration
    result = nil
    ready_timing_events.each do |x|
      duration = x.duration
      if result.nil?
        result = duration
      else
        if duration < result
          result = duration
        end
      end
    end
    result
  end
  
  def maximum_duration
    result = nil
    ready_timing_events.each do |x|
      duration = x.duration
      if result.nil?
        result = duration
      else
        if duration > result
          result = duration
        end
      end
    end
    result
  end
  
  def average_duration
    x = ready_timing_events
    if x.size > 0
      array = x.map{|x| x.duration}
      array.inject{ |sum, el| sum + el }.to_f / array.size
    else
      nil
    end
  end
end
