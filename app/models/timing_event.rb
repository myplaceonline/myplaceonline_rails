class TimingEvent < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :timing
  
  def display
    Myp.seconds_to_time_in_general_human_detailed_hms(duration)
  end

  validates :timing_event_start, presence: true
  validates :timing_event_end, presence: true
  
  validate do
    if timing_event_start > timing_event_end
      errors.add(:timing_event_end, I18n.t("myplaceonline.timing_events.error_end"))
    end
  end

  def duration
    (timing_event_end - timing_event_start).seconds
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.timing_event_start = User.current_user.time_now
    result
  end
end
