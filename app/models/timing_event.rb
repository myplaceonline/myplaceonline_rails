class TimingEvent < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :timing

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
end
