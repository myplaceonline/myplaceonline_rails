class AlertsDisplay < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  def display
    id.to_s
  end
end
