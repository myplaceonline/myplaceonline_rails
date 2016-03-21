class Timing < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :timing_name, presence: true
  
  def display
    timing_name
  end
end
