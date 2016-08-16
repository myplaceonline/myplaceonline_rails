class TimingEvent < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :timing
  
  validates :timing_event_start, presence: true
  #validates :timing_event_end, presence: true
  
  def display
    if ready?
      Myp.seconds_to_time_in_general_human_detailed_hms(duration)
    else
      I18n.t("myplaceonline.timing_events.pending", start: Myp.display_datetime_short(timing_event_start, User.current_user))
    end
  end

  validate do
    if ready? && timing_event_start > timing_event_end
      errors.add(:timing_event_end, I18n.t("myplaceonline.timing_events.error_end"))
    end
  end
  
  def ready?
    !timing_event_end.nil?
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
