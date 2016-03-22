class Timing < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :timing_name, presence: true
  
  has_many :timing_events, :dependent => :destroy
  accepts_nested_attributes_for :timing_events, allow_destroy: true, reject_if: :all_blank

  def display
    timing_name
  end
  
  def minimum_duration
    result = nil
    timing_events.each do |x|
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
    timing_events.each do |x|
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
    if timing_events.size > 0
      array = timing_events.map{|x| x.duration}
      array.inject{ |sum, el| sum + el }.to_f / array.size
    else
      nil
    end
  end
end
